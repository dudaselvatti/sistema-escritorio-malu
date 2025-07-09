package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Processo;
import util.ConnectionFactory;

public class ProcessoDAO {


    public void cadastrar(Processo processo) {
        String sql = "INSERT INTO processos (id_advogado, id_cliente, descricao, status) VALUES (?, ?, ?, ?)";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, processo.getIdAdvogado());
            ps.setInt(2, processo.getIdCliente());
            ps.setString(3, processo.getDescricao());
            ps.setString(4, processo.getStatus());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao cadastrar processo", e);
        }
    }


    public void atualizar(Processo processo) {
        String sql = "UPDATE processos SET id_advogado = ?, id_cliente = ?, descricao = ?, status = ? WHERE id_processos = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, processo.getIdAdvogado());
            ps.setInt(2, processo.getIdCliente());
            ps.setString(3, processo.getDescricao());
            ps.setString(4, processo.getStatus());
            ps.setInt(5, processo.getIdProcesso());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao atualizar processo", e);
        }
    }

    public void excluir(int idProcesso) {
        String sql = "DELETE FROM processos WHERE id_processos = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idProcesso);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao excluir processo", e);
        }
    }
    
    
    public void alterarStatus(int idProcesso, String novoStatus) {
        String sql = "UPDATE processos SET status = ? WHERE id_processos = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, novoStatus);
            ps.setInt(2, idProcesso);
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Erro ao alterar status do processo", e);
        }
    }

    
    public Processo buscarPorId(int idProcesso) {
        Processo proc = null;
        String sql = "SELECT p.*, cli_user.nome AS nome_cliente, adv_user.nome AS nome_advogado " +
                     "FROM processos p " +
                     "JOIN clientes c ON p.id_cliente = c.id_cliente " +
                     "JOIN usuarios cli_user ON c.id_usuario = cli_user.id_usuario " +
                     "JOIN advogados a ON p.id_advogado = a.id_advogado " +
                     "JOIN usuarios adv_user ON a.id_usuario = adv_user.id_usuario " +
                     "WHERE p.id_processos = ?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, idProcesso);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    proc = new Processo();
                    proc.setIdProcesso(rs.getInt("id_processos"));
                    proc.setIdCliente(rs.getInt("id_cliente"));
                    proc.setIdAdvogado(rs.getInt("id_advogado"));
                    proc.setDescricao(rs.getString("descricao"));
                    proc.setStatus(rs.getString("status"));
                    proc.setNomeCliente(rs.getString("nome_cliente"));
                    proc.setNomeAdvogado(rs.getString("nome_advogado"));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao buscar processo por ID", e);
        }
        return proc;
    }

    public List<Processo> listarTodos() {
        return executarConsulta("ORDER BY p.id_processos DESC", null);
    }
    
    public List<Processo> listarPorCliente(int idCliente) {
        return executarConsulta("WHERE p.id_cliente = ? ORDER BY p.id_processos DESC", idCliente);
    }

    public List<Processo> listarPorAdvogado(int idAdvogado) {
        return executarConsulta("WHERE p.id_advogado = ? ORDER BY p.id_processos DESC", idAdvogado);
    }

  
    private List<Processo> executarConsulta(String filtro, Integer idParam) {
        List<Processo> processos = new ArrayList<>();
        String sql = "SELECT p.id_processos, p.descricao, p.status, " +
                     "c.id_cliente, cli_user.nome AS nome_cliente, " +
                     "a.id_advogado, adv_user.nome AS nome_advogado " +
                     "FROM processos p " +
                     "JOIN clientes c ON p.id_cliente = c.id_cliente " +
                     "JOIN usuarios cli_user ON c.id_usuario = cli_user.id_usuario " +
                     "JOIN advogados a ON p.id_advogado = a.id_advogado " +
                     "JOIN usuarios adv_user ON a.id_usuario = adv_user.id_usuario " +
                     (filtro != null ? filtro : "");

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (idParam != null) {
                ps.setInt(1, idParam);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Processo proc = new Processo();
                    proc.setIdProcesso(rs.getInt("id_processos"));
                    proc.setDescricao(rs.getString("descricao"));
                    proc.setStatus(rs.getString("status"));
                    proc.setIdCliente(rs.getInt("id_cliente"));
                    proc.setNomeCliente(rs.getString("nome_cliente"));
                    proc.setIdAdvogado(rs.getInt("id_advogado"));
                    proc.setNomeAdvogado(rs.getString("nome_advogado"));
                    processos.add(proc);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao listar processos: ", e);
        }
        return processos;
    }
}
