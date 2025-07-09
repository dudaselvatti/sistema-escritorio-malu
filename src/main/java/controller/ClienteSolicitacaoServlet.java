package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import dao.ClienteDAO;
import dao.SolicitacaoDAO;
import model.Solicitacao;
import model.Usuario;

@WebServlet("/cliente/solicitacao")
public class ClienteSolicitacaoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SolicitacaoDAO solicitacaoDAO = new SolicitacaoDAO();
    private ClienteDAO clienteDAO = new ClienteDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        action = (action == null) ? "listar" : action;

        switch (action) {
            case "formUpload":
                mostrarFormularioUpload(request, response);
                break;
            default:
                listarMinhasSolicitacoes(request, response);
        }
    }

    private void listarMinhasSolicitacoes(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Usuario usuarioLogado = (Usuario) request.getSession().getAttribute("usuarioLogado");
        if (usuarioLogado != null) {
            int idCliente = clienteDAO.buscarIdClientePorIdUsuario(usuarioLogado.getId());
            if (idCliente != -1) {
                List<Solicitacao> lista = solicitacaoDAO.listarPendentesPorCliente(idCliente);
                request.setAttribute("listaSolicitacoes", lista);
            }
        }
        RequestDispatcher dispatcher = request.getRequestDispatcher("/cliente/minhas_solicitacoes.jsp");
        dispatcher.forward(request, response);
    }

    private void mostrarFormularioUpload(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
       
        request.setAttribute("idSolicitacao", request.getParameter("id"));
        request.setAttribute("nomeDocumento", request.getParameter("nomeDoc"));
        RequestDispatcher dispatcher = request.getRequestDispatcher("/cliente/formUpload.jsp");
        dispatcher.forward(request, response);
    }
}
