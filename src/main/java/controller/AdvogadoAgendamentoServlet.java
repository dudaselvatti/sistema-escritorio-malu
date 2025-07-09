package controller;

import java.io.IOException;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.AgendamentoDAO;
import dao.AdvogadoDAO;
import dao.ClienteDAO;
import model.Agendamento;
import model.Advogado;
import model.ClienteDTO;
import model.Usuario;

@WebServlet("/advogado/agendamento")
public class AdvogadoAgendamentoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AgendamentoDAO agendamentoDAO = new AgendamentoDAO();
    private AdvogadoDAO advogadoDAO = new AdvogadoDAO();
    private ClienteDAO clienteDAO = new ClienteDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        action = (action == null) ? "listar" : action;

        switch (action) {
            case "formNovo":
                mostrarFormulario(request, response, null);
                break;
            case "editar":
                mostrarFormulario(request, response, Integer.parseInt(request.getParameter("id")));
                break;
            case "excluir":
                excluirAgendamento(request, response);
                break;
            case "cancelar":
                cancelarAgendamento(request, response);
                break;
            default:
                listarMeusAgendamentos(request, response);
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("inserir".equals(action) || "atualizar".equals(action)) {
            salvarAgendamento(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void listarMeusAgendamentos(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Usuario usuarioLogado = (Usuario) request.getSession().getAttribute("usuarioLogado");
        if (usuarioLogado != null) {
            int idAdvogado = advogadoDAO.buscarIdAdvogadoPorIdUsuario(usuarioLogado.getId());
            if (idAdvogado != -1) {
                List<Agendamento> listaAgendamentos = agendamentoDAO.listarPorAdvogado(idAdvogado);
                request.setAttribute("listaAgendamentos", listaAgendamentos);
            }
        }
        RequestDispatcher dispatcher = request.getRequestDispatcher("/advogado/meus_agendamentos.jsp");
        dispatcher.forward(request, response);
    }

    private void mostrarFormulario(HttpServletRequest request, HttpServletResponse response, Integer idAgendamento) throws ServletException, IOException {
        Usuario usuarioLogado = (Usuario) request.getSession().getAttribute("usuarioLogado");
        Advogado advogadoLogado = advogadoDAO.buscarPorIdUsuario(usuarioLogado.getId());

        if (idAgendamento != null) {
            Agendamento agendamento = agendamentoDAO.buscarPorId(idAgendamento);
            request.setAttribute("agendamento", agendamento);

            boolean isPast = agendamento.getData().isBefore(LocalDate.now()) ||
                             (agendamento.getData().isEqual(LocalDate.now()) && agendamento.getHora().toLocalTime().isBefore(LocalTime.now()));
            request.setAttribute("isPastAppointment", isPast);
        }

        request.setAttribute("hoje", LocalDate.now().toString());
        List<ClienteDTO> listaClientes = clienteDAO.listarParaDropdown();
        request.setAttribute("listaClientes", listaClientes);
        request.setAttribute("advogadoLogado", advogadoLogado);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/advogado/formMeusAgendamentos.jsp");
        dispatcher.forward(request, response);
    }

    private void salvarAgendamento(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            String idParam = request.getParameter("id");
            int idAgendamento = (idParam != null && !idParam.isEmpty()) ? Integer.parseInt(idParam) : 0;
            boolean isUpdate = idAgendamento > 0;

            Agendamento ag = new Agendamento();
            ag.setIdAgendamento(idAgendamento);
            ag.setDescricao(request.getParameter("descricao"));
            ag.setStatus(request.getParameter("status"));

            if (isUpdate) {
                Agendamento originalAg = agendamentoDAO.buscarPorId(idAgendamento);
                boolean isOriginalPast = originalAg.getData().isBefore(LocalDate.now());

                if (isOriginalPast) {
                    ag.setIdCliente(originalAg.getIdCliente());
                    ag.setIdAdvogado(originalAg.getIdAdvogado());
                    ag.setData(originalAg.getData());
                    ag.setHora(originalAg.getHora());
                } else {
                    int idAdvogado = Integer.parseInt(request.getParameter("idAdvogado"));
                    LocalDate data = LocalDate.parse(request.getParameter("data"));
                    LocalTime hora = LocalTime.parse(request.getParameter("hora"));

                    if (!agendamentoDAO.horarioEstaDisponivel(idAdvogado, data, Time.valueOf(hora), idAgendamento)) {
                        request.setAttribute("erro", "Você já possui um compromisso neste horário.");
                        mostrarFormulario(request, response, idAgendamento);
                        return;
                    }
                    ag.setIdCliente(Integer.parseInt(request.getParameter("idCliente")));
                    ag.setIdAdvogado(idAdvogado);
                    ag.setData(data);
                    ag.setHora(Time.valueOf(hora));
                }
                agendamentoDAO.atualizar(ag);
            } else {
                int idAdvogado = Integer.parseInt(request.getParameter("idAdvogado"));
                LocalDate data = LocalDate.parse(request.getParameter("data"));
                LocalTime hora = LocalTime.parse(request.getParameter("hora"));

                if (data.isBefore(LocalDate.now()) || (data.isEqual(LocalDate.now()) && hora.isBefore(LocalTime.now()))) {
                    request.setAttribute("erro", "Não é possível agendar em uma data ou horário que já passou.");
                    mostrarFormulario(request, response, null);
                    return;
                }
                if (!agendamentoDAO.horarioEstaDisponivel(idAdvogado, data, Time.valueOf(hora), 0)) {
                    request.setAttribute("erro", "Você já possui um compromisso neste horário.");
                    mostrarFormulario(request, response, null);
                    return;
                }

                ag.setIdCliente(Integer.parseInt(request.getParameter("idCliente")));
                ag.setIdAdvogado(idAdvogado);
                ag.setData(data);
                ag.setHora(Time.valueOf(hora));
                agendamentoDAO.cadastrar(ag);
            }
            response.sendRedirect("agendamento?action=listar");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erro", "Ocorreu um erro inesperado ao salvar o agendamento.");
            mostrarFormulario(request, response, null);
        }
    }

    private void excluirAgendamento(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        agendamentoDAO.excluir(id);
        response.sendRedirect("agendamento?action=listar");
    }

    private void cancelarAgendamento(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int idAgendamento = Integer.parseInt(request.getParameter("id"));

        Agendamento ag = agendamentoDAO.buscarPorId(idAgendamento);

        HttpSession session = request.getSession();
        Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
        int idAdvogadoLogado = advogadoDAO.buscarIdAdvogadoPorIdUsuario(usuarioLogado.getId());

        if (ag.getIdAdvogado() != idAdvogadoLogado) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Você não pode cancelar este agendamento.");
            return;
        }

        agendamentoDAO.alterarStatus(idAgendamento, "cancelado");

        response.sendRedirect("agendamento?action=listar");
    }
}