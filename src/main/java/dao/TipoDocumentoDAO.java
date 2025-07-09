package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.TipoDocumento;
import util.ConnectionFactory;

public class TipoDocumentoDAO {

    public List<TipoDocumento> listar() {
        List<TipoDocumento> lista = new ArrayList<>();
        String sql = "SELECT * FROM tipo_documento ORDER BY nome";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                TipoDocumento tipo = new TipoDocumento();
                tipo.setId(rs.getInt("id_tipo_documento"));
                tipo.setNome(rs.getString("nome"));
                lista.add(tipo);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao listar tipos de documento", e);
        }
        return lista;
    }

 
    public TipoDocumento cadastrar(TipoDocumento tipo) {
        String sql = "INSERT INTO tipo_documento (nome) VALUES (?)";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, tipo.getNome());
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    tipo.setId(rs.getInt(1)); 
                }
            }
            return tipo;
        } catch (SQLException e) {
            if (e.getErrorCode() == 1062) { 
                throw new RuntimeException("Já existe um tipo de documento com este nome.");
            }
            throw new RuntimeException("Erro ao cadastrar tipo de documento", e);
        }
    }

    public TipoDocumento buscarPorId(int id) {
        String sql = "SELECT * FROM tipo_documento WHERE id_tipo_documento = ?";
        TipoDocumento tipo = null;
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    tipo = new TipoDocumento();
                    tipo.setId(rs.getInt("id_tipo_documento"));
                    tipo.setNome(rs.getString("nome"));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao buscar tipo de documento por ID", e);
        }
        return tipo;
    }

   
    public TipoDocumento atualizar(TipoDocumento tipo) {
        String sql = "UPDATE tipo_documento SET nome = ? WHERE id_tipo_documento = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tipo.getNome());
            ps.setInt(2, tipo.getId());
            ps.executeUpdate();
            return tipo; 
        } catch (SQLException e) {
             if (e.getErrorCode() == 1062) {
                throw new RuntimeException("Já existe um tipo de documento com este nome.");
            }
            throw new RuntimeException("Erro ao atualizar tipo de documento", e);
        }
    }

    public void excluir(int id) {
        String sql = "DELETE FROM tipo_documento WHERE id_tipo_documento = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            if (e.getErrorCode() == 1451) { // Erro de violação de chave estrangeira
                throw new RuntimeException("Este tipo de documento não pode ser excluído pois está em uso.");
            }
            throw new RuntimeException("Erro ao excluir tipo de documento", e);
        }
    }
}
