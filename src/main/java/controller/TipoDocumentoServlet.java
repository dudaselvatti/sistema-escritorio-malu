package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.google.gson.Gson;
import dao.TipoDocumentoDAO;
import model.TipoDocumento;

@WebServlet("/admin/tipoDocumento")
public class TipoDocumentoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TipoDocumentoDAO tipoDocumentoDAO = new TipoDocumentoDAO();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        action = (action == null) ? "listar" : action;

        switch (action) {
            case "get":
                buscarPorId(request, response);
                break;
            case "excluir":
                excluir(request, response);
                break;
            default:
                listar(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        if ("salvar".equals(action)) {
            salvar(request, response);
        }
    }

    private void listar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<TipoDocumento> lista = tipoDocumentoDAO.listar();
        request.setAttribute("listaTipos", lista);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/tiposDocumento.jsp");
        dispatcher.forward(request, response);
    }
    
    private void buscarPorId(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        int id = Integer.parseInt(request.getParameter("id"));
        TipoDocumento tipoDoc = tipoDocumentoDAO.buscarPorId(id);
        response.getWriter().print(gson.toJson(tipoDoc));
    }
    
    private void salvar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        TipoDocumento tipoDoc = new TipoDocumento();
        String idParam = request.getParameter("id");
        tipoDoc.setNome(request.getParameter("nome"));
        
        try {
            if (idParam != null && !idParam.isEmpty()) {
                tipoDoc.setId(Integer.parseInt(idParam));
                tipoDoc = tipoDocumentoDAO.atualizar(tipoDoc);
            } else {
                tipoDoc = tipoDocumentoDAO.cadastrar(tipoDoc);
            }
            response.getWriter().print(gson.toJson(tipoDoc));
        } catch (RuntimeException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"erro\": \"" + e.getMessage() + "\"}");
        }
    }
    
    private void excluir(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            tipoDocumentoDAO.excluir(id);
            out.print("{\"success\": true, \"message\": \"Tipo de documento excluído com sucesso!\"}");
        } catch (RuntimeException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); 
            out.print("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
        out.flush();
    }
}
