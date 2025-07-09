package controller;

import java.io.IOException;
import java.sql.Date;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import dao.AdvogadoDAO;
import dao.ClienteDAO;
import dao.SolicitacaoDAO;
import dao.TipoDocumentoDAO;
import model.Advogado;
import model.ClienteDTO;
import model.Solicitacao;
import model.TipoDocumento;

@WebServlet("/admin/solicitacao")
public class SolicitacaoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SolicitacaoDAO solicitacaoDAO = new SolicitacaoDAO();
    private AdvogadoDAO advogadoDAO = new AdvogadoDAO();
    private ClienteDAO clienteDAO = new ClienteDAO();
    private TipoDocumentoDAO tipoDocumentoDAO = new TipoDocumentoDAO();

    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        action = (action == null) ? "listar" : action;

        switch (action) {
            case "formNovo":
                mostrarFormulario(request, response);
                break;
            case "inserir":
                inserirSolicitacao(request, response);
                break;
            case "excluir":
                excluirSolicitacao(request, response);
                break;
            case "marcarConcluida":
                alterarStatus(request, response, "concluída");
                break;
            case "cancelar":
                alterarStatus(request, response, "cancelada");
                break;
            default:
                listarSolicitacoes(request, response);
        }
    }

    private void listarSolicitacoes(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Solicitacao> lista = solicitacaoDAO.listarTodas();
        request.setAttribute("listaSolicitacoes", lista);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/solicitacoes.jsp");
        dispatcher.forward(request, response);
    }
    
    private void mostrarFormulario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("listaAdvogados", advogadoDAO.listar());
        request.setAttribute("listaClientes", clienteDAO.listarParaDropdown());
        request.setAttribute("listaTipos", tipoDocumentoDAO.listar());
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/formSolicitacao.jsp");
        dispatcher.forward(request, response);
    }
    
    private void inserirSolicitacao(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            Solicitacao sol = new Solicitacao();
            sol.setIdAdvogado(Integer.parseInt(request.getParameter("idAdvogado")));
            sol.setIdCliente(Integer.parseInt(request.getParameter("idCliente")));
            sol.setIdTipoDocumento(Integer.parseInt(request.getParameter("idTipoDocumento")));
            sol.setDescricao(request.getParameter("descricao"));
            sol.setStatus(request.getParameter("status"));
            
            String dataLimiteParam = request.getParameter("dataLimite");
            if(dataLimiteParam != null && !dataLimiteParam.isEmpty()) {
                sol.setDataLimite(Date.valueOf(dataLimiteParam));
            } else {
                sol.setDataLimite(null);
            }
            
            solicitacaoDAO.cadastrar(sol);
            request.getSession().setAttribute("mensagemSucesso", "Solicitação criada com sucesso!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("mensagemErro", "Erro ao criar solicitação.");
        }
        response.sendRedirect("solicitacao?action=listar");
    }
    
    private void excluirSolicitacao(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            solicitacaoDAO.excluir(id);
            request.getSession().setAttribute("mensagemSucesso", "Solicitação excluída com sucesso.");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("mensagemErro", "Erro ao excluir solicitação.");
        }
        response.sendRedirect("solicitacao?action=listar");
    }

    private void alterarStatus(HttpServletRequest request, HttpServletResponse response, String novoStatus) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            solicitacaoDAO.alterarStatus(id, novoStatus);
            request.getSession().setAttribute("mensagemSucesso", "Status da solicitação alterado com sucesso!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("mensagemErro", "Erro ao alterar status da solicitação.");
        }
        response.sendRedirect("solicitacao?action=listar");
    }
}