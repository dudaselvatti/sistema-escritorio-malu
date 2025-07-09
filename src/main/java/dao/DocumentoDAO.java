package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Documento;
import util.ConnectionFactory;

public class DocumentoDAO {

    public void cadastrar(Documento doc) {
        String sql = "INSERT INTO documentos (id_cliente, id_tipo_documento, titulo, descricao, caminho_arquivo) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doc.getIdCliente());
            ps.setInt(2, doc.getIdTipoDocumento());
            ps.setString(3, doc.getTitulo());
            ps.setString(4, doc.getDescricao());
            ps.setString(5, doc.getCaminhoArquivo());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao cadastrar documento no banco", e);
        }
    }

    public List<Documento> listarTodos() {
        List<Documento> documentos = new ArrayList<>();
        String sql = "SELECT d.*, u.nome AS nome_cliente, td.nome AS nome_tipo_documento " +
                     "FROM documentos d " +
                     "JOIN clientes c ON d.id_cliente = c.id_cliente " +
                     "JOIN usuarios u ON c.id_usuario = u.id_usuario " +
                     "JOIN tipo_documento td ON d.id_tipo_documento = td.id_tipo_documento " +
                     "ORDER BY d.data_upload DESC";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                documentos.add(mapResultSetToDocumento(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao listar documentos", e);
        }
        return documentos;
    }


    public List<Documento> listarPorCliente(int idCliente) {
        List<Documento> documentos = new ArrayList<>();
        String sql = "SELECT d.*, u.nome AS nome_cliente, td.nome AS nome_tipo_documento " +
                     "FROM documentos d " +
                     "JOIN clientes c ON d.id_cliente = c.id_cliente " +
                     "JOIN usuarios u ON c.id_usuario = u.id_usuario " +
                     "JOIN tipo_documento td ON d.id_tipo_documento = td.id_tipo_documento " +
                     "WHERE d.id_cliente = ? ORDER BY d.data_upload DESC";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, idCliente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    documentos.add(mapResultSetToDocumento(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao listar documentos por cliente", e);
        }
        return documentos;
    }

    public Documento buscarPorId(int id) {
        String sql = "SELECT * FROM documentos WHERE id_documento = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Documento doc = new Documento();
                    doc.setId(rs.getInt("id_documento"));
                    doc.setCaminhoArquivo(rs.getString("caminho_arquivo"));
                    return doc;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao buscar documento por ID", e);
        }
        return null;
    }

    public void excluir(int id) {
        String sql = "DELETE FROM documentos WHERE id_documento = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao excluir registro do documento", e);
        }
    }

    private Documento mapResultSetToDocumento(ResultSet rs) throws SQLException {
        Documento doc = new Documento();
        doc.setId(rs.getInt("id_documento"));
        doc.setTitulo(rs.getString("titulo"));
        doc.setDataUpload(rs.getTimestamp("data_upload"));
        doc.setNomeCliente(rs.getString("nome_cliente"));
        doc.setNomeTipoDocumento(rs.getString("nome_tipo_documento")); 
        return doc;
    }
}
