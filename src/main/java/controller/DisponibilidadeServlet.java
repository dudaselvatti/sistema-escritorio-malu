package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.util.Set;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import dao.AgendamentoDAO;


@WebServlet("/disponibilidade")
public class DisponibilidadeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AgendamentoDAO agendamentoDAO = new AgendamentoDAO();
    private Gson gson = new Gson();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            
            int idAdvogado = Integer.parseInt(request.getParameter("idAdvogado"));
            LocalDate data = LocalDate.parse(request.getParameter("data"));
            
            
            Set<String> horariosOcupados = agendamentoDAO.getHorariosOcupados(idAdvogado, data);
            
            String json = gson.toJson(horariosOcupados);
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print(json);
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao verificar disponibilidade.");
        }
    }
}