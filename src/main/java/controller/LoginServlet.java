package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.UsuarioDAO;
import model.Usuario; // Importamos a classe pai



@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        UsuarioDAO dao = new UsuarioDAO();

        Usuario usuario = dao.autenticar(email, senha);

        if (usuario != null) {
        
            HttpSession session = request.getSession();
            session.setAttribute("usuarioLogado", usuario);

            
            String tipo = usuario.getTipoUsuario();

            if ("advogado".equalsIgnoreCase(tipo)) {
                response.sendRedirect(request.getContextPath() + "/advogado/paineladvogado.jsp");
            } else if ("administrador".equalsIgnoreCase(tipo)) {
                response.sendRedirect(request.getContextPath() + "/admin/paineladmin.jsp");
            } else if ("cliente".equalsIgnoreCase(tipo)) {
                response.sendRedirect(request.getContextPath() + "/cliente/painelcliente.jsp");
            } else {
                
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
        } else {
            
            request.setAttribute("erroLogin", "Usuário, senha ou status inválidos.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}
