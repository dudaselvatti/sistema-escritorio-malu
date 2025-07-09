package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import dao.ClienteDAO;
import dao.ProcessoDAO;
import model.Processo;
import model.Usuario;


@WebServlet("/cliente/processo")
public class ClienteProcessoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProcessoDAO processoDAO = new ProcessoDAO();
    private ClienteDAO clienteDAO = new ClienteDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        action = (action == null) ? "listar" : action;

        switch (action) {
            default:
                listarMeusProcessos(request, response);
                break;
        }
    }

    private void listarMeusProcessos(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");

        if (usuarioLogado != null) {
            
            int idCliente = clienteDAO.buscarIdClientePorIdUsuario(usuarioLogado.getId());
            
            if (idCliente != -1) {
                
                List<Processo> listaProcessos = processoDAO.listarPorCliente(idCliente);
                request.setAttribute("listaProcessos", listaProcessos);
            }
        }
        
      
        RequestDispatcher dispatcher = request.getRequestDispatcher("/cliente/meus_processos.jsp");
        dispatcher.forward(request, response);
    }
}
