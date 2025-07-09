package controller;

import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import dao.ClienteDAO;
import dao.DocumentoDAO;
import dao.SolicitacaoDAO;
import model.Documento;
import model.Usuario;

@WebServlet("/cliente/upload")
@MultipartConfig
public class ClienteUploadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIRECTORY = "C:/escritorio_uploads"; // MUDE SE NECESSÁRIO

    private DocumentoDAO documentoDAO = new DocumentoDAO();
    private SolicitacaoDAO solicitacaoDAO = new SolicitacaoDAO();
    private ClienteDAO clienteDAO = new ClienteDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
          
            Part filePart = request.getPart("arquivo");
            String fileName = filePart.getSubmittedFileName();
            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
            
  
            File uploadDir = new File(UPLOAD_DIRECTORY);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            String caminhoCompleto = UPLOAD_DIRECTORY + File.separator + uniqueFileName;
            filePart.write(caminhoCompleto);

  
            Documento doc = new Documento();
            Usuario usuarioLogado = (Usuario) request.getSession().getAttribute("usuarioLogado");
            int idCliente = clienteDAO.buscarIdClientePorIdUsuario(usuarioLogado.getId());
            
            doc.setIdCliente(idCliente);
            doc.setIdTipoDocumento(Integer.parseInt(request.getParameter("idTipoDocumento")));
            doc.setTitulo(request.getParameter("titulo"));
            doc.setCaminhoArquivo(caminhoCompleto);
            documentoDAO.cadastrar(doc);

    
            int idSolicitacao = Integer.parseInt(request.getParameter("idSolicitacao"));
            solicitacaoDAO.alterarStatus(idSolicitacao, "concluída");
            
            request.getSession().setAttribute("mensagemSucesso", "Documento enviado com sucesso!");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("mensagemErro", "Falha no upload do arquivo: " + e.getMessage());
        }
        
 
        response.sendRedirect(request.getContextPath() + "/cliente/solicitacao");
    }
}
