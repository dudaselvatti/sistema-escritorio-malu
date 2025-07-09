package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.Gson; // Lembre-se de ter a biblioteca Gson no seu projeto
import dao.UsuarioDAO;
import model.Advogado;
import model.Usuario;

@WebServlet("/admin/usuario")
public class UsuarioServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UsuarioDAO usuarioDAO = new UsuarioDAO();
    private Gson gson = new Gson(); 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        action = (action == null) ? "listar" : action;

        switch (action) {
            case "formNovo":
            case "editar":
                mostrarFormulario(request, response);
                break;
            case "alterarStatus":
                alterarStatusUsuario(request, response);
                break;
            case "listar":
            default:
                listarUsuarios(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        switch (action) {
            case "inserir":
            case "atualizar":
                salvarUsuario(request, response);
                break;
            default:
                doGet(request, response);
        }
    }

    private void listarUsuarios(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Usuario> listaUsuarios = usuarioDAO.listar();
        request.setAttribute("listaUsuarios", listaUsuarios);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/usuarios.jsp");
        dispatcher.forward(request, response);
    }
    
    private void mostrarFormulario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            Usuario usuario = usuarioDAO.buscarPorId(Integer.parseInt(idParam));
            request.setAttribute("usuario", usuario);
        } else {
            request.setAttribute("usuario", new Usuario());
        }
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/formUsuario.jsp");
        dispatcher.forward(request, response);
    }



    private void salvarUsuario(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        
        String tipoUsuario = request.getParameter("tipoUsuario");
        String idParam = request.getParameter("id");
        String senha = request.getParameter("senha");

        try {
            Usuario usuario;

            
            if ("advogado".equals(tipoUsuario)) {
                Advogado advogado = new Advogado();
                
                
                advogado.setOab(request.getParameter("oab"));
                advogado.setEspecialidade(request.getParameter("especialidade"));
                
                usuario = advogado;
            } else {
               
                usuario = new Usuario();
            }

            
            if (idParam != null && !idParam.isEmpty()) {
                usuario.setId(Integer.parseInt(idParam));
            }
            usuario.setNome(request.getParameter("nome"));
            usuario.setEmail(request.getParameter("email"));
            usuario.setCpf(request.getParameter("cpf"));
            usuario.setEndereco(request.getParameter("endereco"));
            usuario.setBairro(request.getParameter("bairro"));
            usuario.setCidade(request.getParameter("cidade"));
            usuario.setUf(request.getParameter("uf"));
            usuario.setCep(request.getParameter("cep"));
            usuario.setTelefone(request.getParameter("telefone"));
            usuario.setTipoUsuario(tipoUsuario);
            usuario.setAtivo(request.getParameter("ativo"));
            
           
            if (senha != null && !senha.isEmpty()) {
                usuario.setSenha(senha); 
            }

            
            if (usuario.getId() > 0) {
                usuarioDAO.atualizar(usuario); 
            } else {
                usuarioDAO.cadastrar(usuario);
            }
            
            response.sendRedirect("usuario?action=listar");

        } catch (RuntimeException e) {
            
            request.setAttribute("erroCadastro", e.getMessage());
            
            
            Usuario usuarioForm = new Usuario();
             if (idParam != null && !idParam.isEmpty()) {
                usuarioForm.setId(Integer.parseInt(idParam));
            }
            usuarioForm.setNome(request.getParameter("nome"));
            usuarioForm.setEmail(request.getParameter("email"));
            usuarioForm.setCpf(request.getParameter("cpf"));
           

            request.setAttribute("usuario", usuarioForm);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/formUsuario.jsp");
            dispatcher.forward(request, response);
        }
    }

    
    private void alterarStatusUsuario(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String statusAtual = request.getParameter("statusAtual");
            
            String novoStatus = "S".equals(statusAtual) ? "N" : "S";
            
            usuarioDAO.alterarStatus(id, novoStatus);
            
            JsonResponse jsonResponse = new JsonResponse(true, "Status alterado com sucesso!", novoStatus);
            out.print(gson.toJson(jsonResponse));
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // Retorna um erro HTTP
            JsonResponse jsonResponse = new JsonResponse(false, "Erro ao alterar o status.", null);
            out.print(gson.toJson(jsonResponse));
        }
        out.flush();
    }

    
    private class JsonResponse {
        boolean success;
        String message;
        String novoStatus;

        public JsonResponse(boolean success, String message, String novoStatus) {
            this.success = success;
            this.message = message;
            this.novoStatus = novoStatus;
        }
    }
}
