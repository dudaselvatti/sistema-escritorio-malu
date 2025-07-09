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
import model.ClienteDTO; // MODIFICAÇÃO: Usaremos o DTO para o dropdown
import model.Solicitacao;
import model.TipoDocumento;
import model.Usuario;

@WebServlet("/advogado/solicitacao")
public class AdvogadoSolicitacaoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SolicitacaoDAO solicitacaoDAO = new SolicitacaoDAO();
    private AdvogadoDAO advogadoDAO = new AdvogadoDAO();
    private ClienteDAO clienteDAO = new ClienteDAO();
    private TipoDocumentoDAO tipoDocumentoDAO = new TipoDocumentoDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        action = (action == null) ? "listar" : action;

        switch (action) {
            case "formNovo":
                mostrarFormulario(request, response);
                break;
            case "cancelar":
                alterarStatus(request, response, "cancelada");
                break;
            case "excluir":
                excluirSolicitacao(request, response);
                break;
            default:
                listarMinhasSolicitacoes(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("inserir".equals(action)) {
            inserirSolicitacao(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void listarMinhasSolicitacoes(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Usuario usuarioLogado = (Usuario) request.getSession().getAttribute("usuarioLogado");
        if (usuarioLogado != null) {
            int idAdvogado = advogadoDAO.buscarIdAdvogadoPorIdUsuario(usuarioLogado.getId());
            if (idAdvogado != -1) {
                List<Solicitacao> lista = solicitacaoDAO.listarPorAdvogado(idAdvogado);
                request.setAttribute("listaSolicitacoes", lista);
            }
        }
        RequestDispatcher dispatcher = request.getRequestDispatcher("/advogado/minhas_solicitacoes.jsp");
        dispatcher.forward(request, response);
    }
    
    private void mostrarFormulario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Usuario usuarioLogado = (Usuario) request.getSession().getAttribute("usuarioLogado");
        Advogado advogadoLogado = advogadoDAO.buscarPorIdUsuario(usuarioLogado.getId());
        
        
        List<ClienteDTO> listaClientes = clienteDAO.listarParaDropdown();
        List<TipoDocumento> listaTipos = tipoDocumentoDAO.listar();

        request.setAttribute("listaClientes", listaClientes);
        request.setAttribute("listaTipos", listaTipos);
        request.setAttribute("advogadoLogado", advogadoLogado);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/advogado/formMinhaSolicitacao.jsp");
        dispatcher.forward(request, response);
    }
    
    private void inserirSolicitacao(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            Solicitacao sol = new Solicitacao();
            sol.setIdAdvogado(Integer.parseInt(request.getParameter("idAdvogado")));
            sol.setIdCliente(Integer.parseInt(request.getParameter("idCliente")));
            sol.setIdTipoDocumento(Integer.parseInt(request.getParameter("idTipoDocumento")));
            sol.setDescricao(request.getParameter("descricao"));
            sol.setStatus("pendente");
            
            String dataLimiteParam = request.getParameter("dataLimite");
            if(dataLimiteParam != null && !dataLimiteParam.isEmpty()) {
                sol.setDataLimite(Date.valueOf(dataLimiteParam));
            }
            
            solicitacaoDAO.cadastrar(sol);
            request.getSession().setAttribute("mensagemSucesso", "Solicitação criada com sucesso!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("mensagemErro", "Erro ao criar solicitação.");
        }
        response.sendRedirect("solicitacao?action=listar");
    }
    
    private void alterarStatus(HttpServletRequest request, HttpServletResponse response, String novoStatus) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        solicitacaoDAO.alterarStatus(id, novoStatus);
        response.sendRedirect("solicitacao?action=listar");
    }

    private void excluirSolicitacao(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        solicitacaoDAO.excluir(id);
        response.sendRedirect("solicitacao?action=listar");
    }
}
