package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Solicitacao;
import util.ConnectionFactory;

public class SolicitacaoDAO {

    public void cadastrar(Solicitacao solicitacao) {
        String sql = "INSERT INTO solicitacoes (id_advogado, id_cliente, id_tipo_documento, descricao, status, data_limite) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, solicitacao.getIdAdvogado());
            ps.setInt(2, solicitacao.getIdCliente());
            ps.setInt(3, solicitacao.getIdTipoDocumento());
            ps.setString(4, solicitacao.getDescricao());
            ps.setString(5, solicitacao.getStatus());
            ps.setDate(6, solicitacao.getDataLimite());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao cadastrar solicitação", e);
        }
    }

    public List<Solicitacao> listarTodas() {
        List<Solicitacao> solicitacoes = new ArrayList<>();
        String sql = "SELECT s.*, adv_user.nome AS nome_advogado, cli_user.nome AS nome_cliente, td.nome AS nome_tipo_documento " +
                     "FROM solicitacoes s " +
                     "JOIN advogados a ON s.id_advogado = a.id_advogado " +
                     "JOIN usuarios adv_user ON a.id_usuario = adv_user.id_usuario " +
                     "JOIN clientes c ON s.id_cliente = c.id_cliente " +
                     "JOIN usuarios cli_user ON c.id_usuario = cli_user.id_usuario " +
                     "JOIN tipo_documento td ON s.id_tipo_documento = td.id_tipo_documento " +
                     "ORDER BY s.data_criacao DESC";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Solicitacao sol = new Solicitacao();
                sol.setIdSolicitacao(rs.getInt("id_solicitacao"));
                sol.setDescricao(rs.getString("descricao"));
                sol.setStatus(rs.getString("status"));
                sol.setDataCriacao(rs.getTimestamp("data_criacao"));
                sol.setDataLimite(rs.getDate("data_limite"));
                sol.setNomeAdvogado(rs.getString("nome_advogado"));
                sol.setNomeCliente(rs.getString("nome_cliente"));
                sol.setNomeTipoDocumento(rs.getString("nome_tipo_documento"));
                solicitacoes.add(sol);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao listar solicitações", e);
        }
        return solicitacoes;
    }

    public List<Solicitacao> listarPorAdvogado(int idAdvogado) {
        List<Solicitacao> solicitacoes = new ArrayList<>();
        String sql = "SELECT s.*, adv_user.nome AS nome_advogado, cli_user.nome AS nome_cliente, td.nome AS nome_tipo_documento " +
                     "FROM solicitacoes s " +
                     "JOIN advogados a ON s.id_advogado = a.id_advogado " +
                     "JOIN usuarios adv_user ON a.id_usuario = adv_user.id_usuario " +
                     "JOIN clientes c ON s.id_cliente = c.id_cliente " +
                     "JOIN usuarios cli_user ON c.id_usuario = cli_user.id_usuario " +
                     "JOIN tipo_documento td ON s.id_tipo_documento = td.id_tipo_documento " +
                     "WHERE s.id_advogado = ? ORDER BY s.data_criacao DESC";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, idAdvogado);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Solicitacao sol = new Solicitacao();
                    sol.setIdSolicitacao(rs.getInt("id_solicitacao"));
                    sol.setDescricao(rs.getString("descricao"));
                    sol.setStatus(rs.getString("status"));
                    sol.setDataCriacao(rs.getTimestamp("data_criacao"));
                    sol.setDataLimite(rs.getDate("data_limite"));
                    sol.setNomeAdvogado(rs.getString("nome_advogado"));
                    sol.setNomeCliente(rs.getString("nome_cliente"));
                    sol.setNomeTipoDocumento(rs.getString("nome_tipo_documento"));
                    solicitacoes.add(sol);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao listar solicitações por advogado", e);
        }
        return solicitacoes;
    }
    

    public List<Solicitacao> listarPendentesPorCliente(int idCliente) {
        List<Solicitacao> solicitacoes = new ArrayList<>();
        String sql = "SELECT s.*, adv_user.nome AS nome_advogado, td.nome AS nome_tipo_documento " +
                     "FROM solicitacoes s " +
                     "JOIN advogados a ON s.id_advogado = a.id_advogado " +
                     "JOIN usuarios adv_user ON a.id_usuario = adv_user.id_usuario " +
                     "JOIN tipo_documento td ON s.id_tipo_documento = td.id_tipo_documento " +
                     "WHERE s.id_cliente = ? AND s.status = 'pendente' " +
                     "ORDER BY s.data_criacao DESC";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, idCliente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Solicitacao sol = new Solicitacao();
                    sol.setIdSolicitacao(rs.getInt("id_solicitacao"));
                    sol.setIdTipoDocumento(rs.getInt("id_tipo_documento"));
                    sol.setDescricao(rs.getString("descricao"));
                    sol.setStatus(rs.getString("status"));
                    sol.setDataCriacao(rs.getTimestamp("data_criacao"));
                    sol.setDataLimite(rs.getDate("data_limite"));
                    sol.setNomeAdvogado(rs.getString("nome_advogado"));
                    sol.setNomeTipoDocumento(rs.getString("nome_tipo_documento"));
                    solicitacoes.add(sol);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao listar solicitações pendentes por cliente", e);
        }
        return solicitacoes;
    }

    public void excluir(int id) {
        String sql = "DELETE FROM solicitacoes WHERE id_solicitacao = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao excluir solicitação", e);
        }
    }
    
    public void alterarStatus(int idSolicitacao, String novoStatus) {
        String sql = "UPDATE solicitacoes SET status = ? WHERE id_solicitacao = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, novoStatus);
            ps.setInt(2, idSolicitacao);
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Erro ao alterar status da solicitação", e);
        }
    }
}
