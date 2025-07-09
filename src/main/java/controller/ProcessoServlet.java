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
import com.google.gson.Gson;
import dao.ProcessoDAO;
import model.Processo;

@WebServlet("/admin/processo")
public class ProcessoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProcessoDAO processoDAO = new ProcessoDAO();
    private Gson gson = new Gson();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        action = (action == null) ? "listarTodos" : action;

        switch (action) {
            case "listarPorCliente":
                listarProcessosPorCliente(request, response);
                break;
            case "getDetalhes":
                buscarDetalhes(request, response);
                break;
            default:
                listarTodosProcessos(request, response);
                break;
        }
    }

    private void listarTodosProcessos(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Processo> listaProcessos = processoDAO.listarTodos();
        request.setAttribute("listaProcessos", listaProcessos);
        request.setAttribute("tituloPagina", "Todos os Processos");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/processos.jsp");
        dispatcher.forward(request, response);
    }
    
    private void listarProcessosPorCliente(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idCliente = Integer.parseInt(request.getParameter("idCliente"));
        List<Processo> listaProcessos = processoDAO.listarPorCliente(idCliente);
        
        request.setAttribute("listaProcessos", listaProcessos);
        String nomeCliente = listaProcessos.isEmpty() ? "" : listaProcessos.get(0).getNomeCliente();
        request.setAttribute("tituloPagina", "Processos de " + nomeCliente);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/processos.jsp");
        dispatcher.forward(request, response);
    }
    
    private void buscarDetalhes(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        int id = Integer.parseInt(request.getParameter("id"));
        

        Processo processo = processoDAO.buscarPorId(id);
        
        response.getWriter().print(gson.toJson(processo));
    }
}
