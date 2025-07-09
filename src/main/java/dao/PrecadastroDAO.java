package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Precadastro;
import util.ConnectionFactory;

public class PrecadastroDAO {


    public boolean cpfExiste(String cpf) {
        String sql = "SELECT COUNT(*) FROM precadastro WHERE CPF = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, cpf);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao verificar CPF no pré-cadastro", e);
        }
        return false;
    }

    public List<Precadastro> listar() {
        List<Precadastro> lista = new ArrayList<>();
        String sql = "SELECT * FROM precadastro ORDER BY id_precad DESC";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Precadastro pc = new Precadastro();
                pc.setId(rs.getInt("id_precad"));
                pc.setCpf(rs.getString("CPF"));
                lista.add(pc);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao listar CPFs pré-cadastrados", e);
        }
        return lista;
    }


    public void cadastrar(String cpf) {
        String sql = "INSERT INTO precadastro (CPF) VALUES (?)";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, cpf.replaceAll("[^0-9]", "")); 
            ps.executeUpdate();
        } catch (SQLException e) {
            if (e.getErrorCode() == 1062) {
                throw new RuntimeException("Este CPF já está pré-cadastrado.");
            }
            throw new RuntimeException("Erro ao cadastrar CPF", e);
        }
    }

 
    public void excluir(int id) {
        String sql = "DELETE FROM precadastro WHERE id_precad = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao excluir CPF", e);
        }
    }
}
