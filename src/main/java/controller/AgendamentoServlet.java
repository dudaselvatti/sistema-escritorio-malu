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

import dao.AgendamentoDAO;
import dao.AdvogadoDAO;
import dao.ClienteDAO;
import model.Agendamento;
import model.Advogado;
import model.ClienteDTO;

@WebServlet("/admin/agendamento")
public class AgendamentoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AgendamentoDAO agendamentoDAO = new AgendamentoDAO();
    private ClienteDAO clienteDAO = new ClienteDAO();
    private AdvogadoDAO advogadoDAO = new AdvogadoDAO();

    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        action = (action == null) ? "listar" : action;

        switch (action) {
            case "formNovo":
                mostrarFormulario(request, response, null);
                break;
            case "inserir":
            case "atualizar":
                salvarAgendamento(request, response);
                break;
            case "editar":
                mostrarFormulario(request, response, Integer.parseInt(request.getParameter("id")));
                break;
            case "excluir":
                excluirAgendamento(request, response);
                break;
            default:
                listarAgendamentos(request, response);
        }
    }

    private void listarAgendamentos(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Agendamento> listaAgendamentos = agendamentoDAO.listarTodos();
        request.setAttribute("listaAgendamentos", listaAgendamentos);
        request.setAttribute("tituloPagina", "Todos os Agendamentos");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/agendamentos.jsp");
        dispatcher.forward(request, response);
    }
    
    private void mostrarFormulario(HttpServletRequest request, HttpServletResponse response, Integer idAgendamento) throws ServletException, IOException {
        if (idAgendamento != null) {
            Agendamento agendamento = agendamentoDAO.buscarPorId(idAgendamento);
            request.setAttribute("agendamento", agendamento);
         
            boolean isPast = agendamento.getData().isBefore(LocalDate.now()) || 
                             (agendamento.getData().isEqual(LocalDate.now()) && agendamento.getHora().toLocalTime().isBefore(LocalTime.now()));
            request.setAttribute("isPastAppointment", isPast);
        }
        
        request.setAttribute("hoje", LocalDate.now().toString());
        List<ClienteDTO> listaClientes = clienteDAO.listarParaDropdown();
        List<Advogado> listaAdvogados = advogadoDAO.listar();
        request.setAttribute("listaClientes", listaClientes);
        request.setAttribute("listaAdvogados", listaAdvogados);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/formAgendamento.jsp");
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
                        request.setAttribute("erro", "Este horário já está ocupado para o advogado selecionado.");
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
                ag.setIdCliente(Integer.parseInt(request.getParameter("idCliente")));
                ag.setIdAdvogado(Integer.parseInt(request.getParameter("idAdvogado")));
                ag.setData(LocalDate.parse(request.getParameter("data")));
                ag.setHora(Time.valueOf(request.getParameter("hora") + ":00"));
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
}