package controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import dao.DocumentoDAO;
import model.Documento;

@WebServlet("/advogado/documento")
public class AdvogadoDocumentoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DocumentoDAO documentoDAO = new DocumentoDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        action = (action == null) ? "listar" : action;

        switch (action) {
            case "listarPorCliente":
                listarDocumentosPorCliente(request, response);
                break;
            case "download":
                baixarDocumento(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/advogado/cliente");
        }
    }

    private void listarDocumentosPorCliente(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int idCliente = Integer.parseInt(request.getParameter("idCliente"));
            List<Documento> listaDocumentos = documentoDAO.listarPorCliente(idCliente);
            

            String nomeCliente = listaDocumentos.isEmpty() ? "" : listaDocumentos.get(0).getNomeCliente();
            
            request.setAttribute("listaDocumentos", listaDocumentos);
            request.setAttribute("nomeCliente", nomeCliente);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/advogado/meus_documentos_cliente.jsp");
            dispatcher.forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/advogado/cliente");
        }
    }

    private void baixarDocumento(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Documento doc = documentoDAO.buscarPorId(id);
        
        if (doc != null && doc.getCaminhoArquivo() != null) {
            File file = new File(doc.getCaminhoArquivo());
            if (file.exists()) {
                response.setContentType("application/octet-stream");
                response.setContentLength((int) file.length());
                response.setHeader("Content-Disposition", "attachment; filename=\"" + file.getName() + "\"");

                try (FileInputStream in = new FileInputStream(file);
                     OutputStream out = response.getOutputStream()) {
                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    while ((bytesRead = in.read(buffer)) != -1) {
                        out.write(buffer, 0, bytesRead);
                    }
                }
            }
        }
    }
}
