package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.google.gson.Gson; // Lembre-se de ter a biblioteca Gson no seu projeto
import dao.PrecadastroDAO;
import model.Precadastro;

@WebServlet("/admin/precadastro")
public class PrecadastroServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PrecadastroDAO precadastroDAO = new PrecadastroDAO();
    private Gson gson = new Gson();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        action = (action == null) ? "listar" : action;

        switch (action) {
            case "excluir":
                excluirCPF(request, response);
                break;
            default:
                listarCPFs(request, response);
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("inserir".equals(action)) {
            inserirCPF(request, response);
        }
    }

    private void listarCPFs(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Precadastro> lista = precadastroDAO.listar();
        request.setAttribute("listaPrecadastro", lista);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/precadastro.jsp");
        dispatcher.forward(request, response);
    }

    private void inserirCPF(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String cpf = request.getParameter("cpf");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            precadastroDAO.cadastrar(cpf);
            out.print("{\"success\": true, \"message\": \"CPF pré-cadastrado com sucesso!\"}");
        } catch (RuntimeException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); 
            out.print("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
        out.flush();
    }

    private void excluirCPF(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            precadastroDAO.excluir(id);
            request.getSession().setAttribute("mensagemSucesso", "CPF removido com sucesso!");
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", "Erro ao remover CPF.");
        }
        response.sendRedirect("precadastro?action=listar");
    }
}
