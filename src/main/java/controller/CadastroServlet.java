package controller;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.PrecadastroDAO;
import dao.UsuarioDAO;
import model.Advogado;
import model.Cliente;
import model.Usuario;

@WebServlet("/cadastro")
public class CadastroServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UsuarioDAO usuarioDAO = new UsuarioDAO();
    private PrecadastroDAO precadastroDAO = new PrecadastroDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String cpf = request.getParameter("cpf").replaceAll("[^0-9]", "");
        String tipoUsuario = request.getParameter("tipoUsuario");
        

        boolean podeSerAdvogado = precadastroDAO.cpfExiste(cpf);
        
        if ("advogado".equalsIgnoreCase(tipoUsuario) && !podeSerAdvogado) {
            request.setAttribute("erroCadastro", "Este CPF não está pré-cadastrado para advogados.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/cadastro.jsp");
            dispatcher.forward(request, response);
            return; 
        }
        

        Usuario novoUsuario;
        
        if ("advogado".equalsIgnoreCase(tipoUsuario)) {
            Advogado adv = new Advogado();
            adv.setOab(request.getParameter("oab"));
            adv.setEspecialidade(request.getParameter("especialidade"));
            novoUsuario = adv;
        } else {

            novoUsuario = new Cliente();
        }

        novoUsuario.setNome(request.getParameter("nome"));
        novoUsuario.setEmail(request.getParameter("email"));
        novoUsuario.setSenha(request.getParameter("senha"));
        novoUsuario.setCpf(cpf);
        novoUsuario.setEndereco(request.getParameter("endereco"));
        novoUsuario.setBairro(request.getParameter("bairro"));
        novoUsuario.setCidade(request.getParameter("cidade"));
        novoUsuario.setUf(request.getParameter("uf"));
        novoUsuario.setCep(request.getParameter("cep"));
        novoUsuario.setTelefone(request.getParameter("telefone"));
        novoUsuario.setTipoUsuario(tipoUsuario);
        novoUsuario.setAtivo("S"); 

        try {
            usuarioDAO.cadastrar(novoUsuario);
            
            response.sendRedirect(request.getContextPath() + "/index.jsp?cadastro=sucesso");

        } catch (RuntimeException e) {
            request.setAttribute("erroCadastro", e.getMessage());
            request.setAttribute("usuario", novoUsuario); 
            RequestDispatcher dispatcher = request.getRequestDispatcher("/cadastro.jsp");
            dispatcher.forward(request, response);
        }
    }
}
