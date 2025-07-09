package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import dao.AdvogadoDAO;
import model.Advogado;

@WebServlet("/admin/advogado")
public class AdvogadoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AdvogadoDAO advogadoDAO = new AdvogadoDAO();

    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        action = (action == null) ? "listar" : action;

        switch (action) {
            case "listar":
                listarAdvogados(request, response);
                break;
            case "editar":
                mostrarFormularioEdicao(request, response);
                break;
            case "atualizar":
                atualizarAdvogado(request, response);
                break;
            default:
                listarAdvogados(request, response);
        }
    }

    private void listarAdvogados(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Advogado> listaAdvogados = advogadoDAO.listar();
        request.setAttribute("listaAdvogados", listaAdvogados);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/advogados.jsp");
        dispatcher.forward(request, response);
    }
    
    private void mostrarFormularioEdicao(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Advogado advogado = advogadoDAO.buscarPorIdUsuario(id);
        request.setAttribute("advogado", advogado);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/formAdvogado.jsp");
        dispatcher.forward(request, response);
    }

    private void atualizarAdvogado(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Advogado adv = new Advogado();
        
        adv.setId(Integer.parseInt(request.getParameter("idUsuario")));
        
        adv.setOab(request.getParameter("oab"));
        adv.setEspecialidade(request.getParameter("especialidade"));
        
        advogadoDAO.atualizar(adv);
        response.sendRedirect("advogado?action=listar");
    }
}
