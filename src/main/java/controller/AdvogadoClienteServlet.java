package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import dao.AdvogadoDAO;
import dao.ClienteDAO;
import model.Cliente;
import model.Usuario;

@WebServlet("/advogado/cliente")
public class AdvogadoClienteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ClienteDAO clienteDAO = new ClienteDAO();
    private AdvogadoDAO advogadoDAO = new AdvogadoDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");

        if (usuarioLogado != null) {
            int idAdvogado = advogadoDAO.buscarIdAdvogadoPorIdUsuario(usuarioLogado.getId());
            if (idAdvogado != -1) {
                List<Cliente> listaClientes = clienteDAO.listarPorAdvogado(idAdvogado);
                request.setAttribute("listaClientes", listaClientes);
            }
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/advogado/meus_clientes.jsp");
        dispatcher.forward(request, response);
    }
}
