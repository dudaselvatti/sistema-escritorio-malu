package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.Gson; // Você precisará da biblioteca GSON
import dao.AdvogadoDAO;
import model.Advogado;

@WebServlet("/advogadosPorEspecialidade")
public class AdvogadoPorEspecialidadeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AdvogadoDAO advogadoDAO = new AdvogadoDAO();
    private Gson gson = new Gson();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String especialidade = request.getParameter("especialidade");
        
        List<Advogado> advogados = advogadoDAO.listarPorEspecialidade(especialidade);
        
        String json = gson.toJson(advogados);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
    }
}
