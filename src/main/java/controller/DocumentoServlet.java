package controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import dao.ClienteDAO;
import dao.DocumentoDAO;
import dao.TipoDocumentoDAO;
import model.ClienteDTO;
import model.Documento;
import model.TipoDocumento;

@WebServlet("/admin/documento")
@MultipartConfig 
public class DocumentoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
   
    private static final String UPLOAD_DIRECTORY = "C:/escritorio_uploads";

    private DocumentoDAO documentoDAO = new DocumentoDAO();
    private ClienteDAO clienteDAO = new ClienteDAO();
    private TipoDocumentoDAO tipoDocumentoDAO = new TipoDocumentoDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        action = (action == null) ? "listar" : action;

        switch (action) {
            case "formNovo":
                mostrarFormulario(request, response);
                break;
            case "download":
                baixarDocumento(request, response);
                break;
            case "excluir":
                excluirDocumento(request, response);
                break;
            default:
                listarDocumentos(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("upload".equals(action)) {
            fazerUpload(request, response);
        }
    }

    private void listarDocumentos(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Documento> listaDocumentos = documentoDAO.listarTodos();
        request.setAttribute("listaDocumentos", listaDocumentos);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/documentos.jsp");
        dispatcher.forward(request, response);
    }
    
    private void mostrarFormulario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<ClienteDTO> listaClientes = clienteDAO.listarParaDropdown();
        List<TipoDocumento> listaTipos = tipoDocumentoDAO.listar();
        request.setAttribute("listaClientes", listaClientes);
        request.setAttribute("listaTipos", listaTipos);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/formDocumento.jsp");
        dispatcher.forward(request, response);
    }
    
    private void fazerUpload(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            Part filePart = request.getPart("arquivo");
            String fileName = filePart.getSubmittedFileName();
            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
            
            File uploadDir = new File(UPLOAD_DIRECTORY);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            
            String caminhoCompleto = UPLOAD_DIRECTORY + File.separator + uniqueFileName;
            filePart.write(caminhoCompleto);

            Documento doc = new Documento();
            doc.setIdCliente(Integer.parseInt(request.getParameter("idCliente")));
            doc.setIdTipoDocumento(Integer.parseInt(request.getParameter("idTipoDocumento")));
            doc.setTitulo(request.getParameter("titulo"));
            doc.setDescricao(request.getParameter("descricao"));
            doc.setCaminhoArquivo(caminhoCompleto);
            
            documentoDAO.cadastrar(doc);
            response.sendRedirect("documento?action=listar");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erro", "Falha no upload do arquivo: " + e.getMessage());
            mostrarFormulario(request, response);
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
    
    private void excluirDocumento(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Documento doc = documentoDAO.buscarPorId(id);
        
        if (doc != null && doc.getCaminhoArquivo() != null) {
            File file = new File(doc.getCaminhoArquivo());
            if (file.exists()) {
                file.delete(); 
            }
        }
        documentoDAO.excluir(id); 
        response.sendRedirect("documento?action=listar");
    }
}
