package controller;

import java.io.IOException;
import java.sql.Time;
import java.time.LocalDate;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.AdvogadoDAO;
import dao.ClienteDAO;
import dao.ProcessoDAO;
import model.Advogado;
import model.Cliente; // MODIFICAÇÃO: Importa a classe Cliente completa
import model.ClienteDTO;
import model.Processo;
import model.Usuario;

@WebServlet("/advogado/processo")
public class AdvogadoProcessoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProcessoDAO processoDAO = new ProcessoDAO();
    private AdvogadoDAO advogadoDAO = new AdvogadoDAO();
    private ClienteDAO clienteDAO = new ClienteDAO();

    @Override
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
            case "cancelar":
                alterarStatus(request, response, "cancelado");
                break;
            default:
                listarMeusProcessos(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        if ("inserir".equals(action) || "atualizar".equals(action)) {
            salvarProcesso(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void listarMeusProcessos(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Usuario usuarioLogado = (Usuario) request.getSession().getAttribute("usuarioLogado");
        if (usuarioLogado != null) {
            int idAdvogado = advogadoDAO.buscarIdAdvogadoPorIdUsuario(usuarioLogado.getId());
            if (idAdvogado != -1) {
                List<Processo> listaProcessos = processoDAO.listarPorAdvogado(idAdvogado);
                request.setAttribute("listaProcessos", listaProcessos);
            }
        }
        RequestDispatcher dispatcher = request.getRequestDispatcher("/advogado/meus_processos.jsp");
        dispatcher.forward(request, response);
    }
    
    private void mostrarFormulario(HttpServletRequest request, HttpServletResponse response, Integer idProcesso) throws ServletException, IOException {
        Usuario usuarioLogado = (Usuario) request.getSession().getAttribute("usuarioLogado");
        Advogado advogadoLogado = advogadoDAO.buscarPorIdUsuario(usuarioLogado.getId());
        
        if (idProcesso != null) {
            Processo processo = processoDAO.buscarPorId(idProcesso);
            request.setAttribute("processo", processo);
        }
        
   
        List<ClienteDTO> listaClientes = clienteDAO.listarParaDropdown();
        
        request.setAttribute("listaClientes", listaClientes);
        request.setAttribute("advogadoLogado", advogadoLogado);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/advogado/formMeusProcessos.jsp");
        dispatcher.forward(request, response);
    }
    
    private void salvarProcesso(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Processo proc = new Processo();
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            proc.setIdProcesso(Integer.parseInt(idParam));
        }
        
        proc.setIdCliente(Integer.parseInt(request.getParameter("idCliente")));
        proc.setIdAdvogado(Integer.parseInt(request.getParameter("idAdvogado")));
        proc.setDescricao(request.getParameter("descricao"));
        proc.setStatus(request.getParameter("status"));

        if (proc.getIdProcesso() > 0) {
            processoDAO.atualizar(proc);
        } else {
            processoDAO.cadastrar(proc);
        }
        response.sendRedirect("processo?action=listar");
    }
    
    private void alterarStatus(HttpServletRequest request, HttpServletResponse response, String novoStatus) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        processoDAO.alterarStatus(id, novoStatus);
        response.sendRedirect("processo?action=listar");
    }
    
    private void excluirProcesso(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        processoDAO.excluir(id);
        response.sendRedirect("processo?action=listar");
    }
}
