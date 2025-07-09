package controller;

import java.io.IOException;
import java.sql.Date;
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

// DAOs e Modelos necessários
import dao.AgendamentoDAO;
import dao.AdvogadoDAO;
import dao.ClienteDAO;
import model.Agendamento;
import model.Usuario;

@WebServlet("/cliente/agendamento")
public class ClienteAgendamentoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private AgendamentoDAO agendamentoDAO = new AgendamentoDAO();
    private ClienteDAO clienteDAO = new ClienteDAO();
    private AdvogadoDAO advogadoDAO = new AdvogadoDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        action = (action == null) ? "listar" : action;

        switch (action) {
            case "formNovo":
                mostrarFormulario(request, response);
                break;
            case "cancelar":
                alterarStatus(request, response, "cancelado");
                break;
            case "listar":
            default:
                listarMeusAgendamentos(request, response);
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("inserir".equals(action)) {
            inserirAgendamento(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void listarMeusAgendamentos(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Usuario usuarioLogado = (Usuario) request.getSession().getAttribute("usuarioLogado");
        if (usuarioLogado != null) {
            int idCliente = clienteDAO.buscarIdClientePorIdUsuario(usuarioLogado.getId());
            if (idCliente != -1) {
                List<Agendamento> listaAgendamentos = agendamentoDAO.listarPorCliente(idCliente);
                request.setAttribute("listaAgendamentos", listaAgendamentos);
            }
        }
        RequestDispatcher dispatcher = request.getRequestDispatcher("/cliente/meus_agendamentos.jsp");
        dispatcher.forward(request, response);
    }
    
    private void mostrarFormulario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<String> especialidades = advogadoDAO.listarEspecialidades();
        request.setAttribute("listaEspecialidades", especialidades);
        request.setAttribute("hoje", LocalDate.now().toString()); // Passa a data de hoje para o formulário
        RequestDispatcher dispatcher = request.getRequestDispatcher("/cliente/formNovoAgendamento.jsp");
        dispatcher.forward(request, response);
    }
    
    private void inserirAgendamento(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            int idAdvogado = Integer.parseInt(request.getParameter("idAdvogado"));
            LocalDate data = LocalDate.parse(request.getParameter("data"));
            LocalTime hora = LocalTime.parse(request.getParameter("hora"));
            
           
            if (data.isBefore(LocalDate.now())) {
                request.setAttribute("erro", "Não é possível agendar em uma data que já passou.");
                mostrarFormulario(request, response);
                return;
            }
            
            
            if (data.isEqual(LocalDate.now()) && hora.isBefore(LocalTime.now())) {
                request.setAttribute("erro", "Não é possível agendar em um horário que já passou hoje.");
                mostrarFormulario(request, response);
                return;
            }

            LocalTime horaMinima = LocalTime.of(9, 0);
            LocalTime horaMaxima = LocalTime.of(17, 0);
            if (hora.isBefore(horaMinima) || hora.isAfter(horaMaxima)) {
                request.setAttribute("erro", "Horário inválido. Por favor, escolha um horário entre 09:00 e 17:00.");
                mostrarFormulario(request, response);
                return;
            }


            if (!agendamentoDAO.horarioEstaDisponivel(idAdvogado, data, Time.valueOf(hora), 0)) {
                request.setAttribute("erro", "Este horário já está ocupado para o advogado selecionado. Por favor, escolha outro.");
                mostrarFormulario(request, response);
                return;
            }

            Usuario usuarioLogado = (Usuario) request.getSession().getAttribute("usuarioLogado");
            int idCliente = clienteDAO.buscarIdClientePorIdUsuario(usuarioLogado.getId());

            Agendamento ag = new Agendamento();
            ag.setIdCliente(idCliente);
            ag.setIdAdvogado(idAdvogado);
            ag.setData(data);
            ag.setHora(Time.valueOf(hora));
            ag.setDescricao(request.getParameter("descricao"));
            ag.setStatus("agendado");

            agendamentoDAO.cadastrar(ag);
            request.getSession().setAttribute("mensagemSucesso", "Agendamento solicitado com sucesso!");
            response.sendRedirect(request.getContextPath() + "/cliente/agendamento?action=listar");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("mensagemErro", "Erro ao solicitar agendamento.");
            response.sendRedirect(request.getContextPath() + "/cliente/agendamento?action=listar");
        }
    }
    
    private void alterarStatus(HttpServletRequest request, HttpServletResponse response, String novoStatus) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            agendamentoDAO.alterarStatus(id, novoStatus);
            request.getSession().setAttribute("mensagemSucesso", "Agendamento cancelado com sucesso!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("mensagemErro", "Erro ao cancelar o agendamento.");
        }
        response.sendRedirect(request.getContextPath() + "/cliente/agendamento?action=listar");
    }
}