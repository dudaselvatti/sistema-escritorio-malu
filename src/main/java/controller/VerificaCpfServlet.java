package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.PrecadastroDAO;

@WebServlet("/verificaCpf")
public class VerificaCpfServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PrecadastroDAO precadastroDAO = new PrecadastroDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String cpf = request.getParameter("cpf");
        
       
        cpf = cpf != null ? cpf.replaceAll("[^0-9]", "") : "";

        boolean podeSerAdvogado = false;
        if (cpf.length() == 11) {
            podeSerAdvogado = precadastroDAO.cpfExiste(cpf);
        }
        
      
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print("{ \"podeSerAdvogado\": " + podeSerAdvogado + " }");
        out.flush();
    }
}