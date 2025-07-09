package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Advogado;
import util.ConnectionFactory;

public class AdvogadoDAO {


    public List<Advogado> listar() {
        List<Advogado> advogados = new ArrayList<>();
        String sql = "SELECT u.*, a.id_advogado, a.oab, a.especialidade " +
                     "FROM usuarios u INNER JOIN advogados a ON u.id_usuario = a.id_usuario " +
                     "WHERE u.tipo_usuario = 'advogado' AND u.ativo = 'S' ORDER BY u.nome";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Advogado adv = new Advogado();
               
                adv.setId(rs.getInt("id_usuario"));
                adv.setNome(rs.getString("nome"));
                adv.setEmail(rs.getString("email"));
               
                adv.setIdAdvogado(rs.getInt("id_advogado"));
                adv.setOab(rs.getString("oab"));
                adv.setEspecialidade(rs.getString("especialidade"));
                advogados.add(adv);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao listar advogados: ", e);
        }
        return advogados;
    }

   
    public Advogado buscarPorIdUsuario(int idUsuario) {
        Advogado adv = null;
        String sql = "SELECT u.*, a.id_advogado, a.oab, a.especialidade " +
                     "FROM usuarios u INNER JOIN advogados a ON u.id_usuario = a.id_usuario " +
                     "WHERE u.id_usuario = ?";
                     
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    adv = new Advogado();
                    adv.setId(rs.getInt("id_usuario")); // Corrigido
                    adv.setIdAdvogado(rs.getInt("id_advogado"));
                    adv.setNome(rs.getString("nome"));
                    adv.setEmail(rs.getString("email"));
                    adv.setOab(rs.getString("oab"));
                    adv.setEspecialidade(rs.getString("especialidade"));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao buscar advogado por ID de usuário: ", e);
        }
        return adv;
    }

    
    public void atualizar(Advogado advogado) {
        String sql = "UPDATE advogados SET oab = ?, especialidade = ? WHERE id_usuario = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, advogado.getOab());
            ps.setString(2, advogado.getEspecialidade());
            ps.setInt(3, advogado.getId()); // Usa o getId() herdado de Usuario
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao atualizar dados do advogado: ", e);
        }
    }

    
    public int buscarIdAdvogadoPorIdUsuario(int idUsuario) {
        String sql = "SELECT id_advogado FROM advogados WHERE id_usuario = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id_advogado");
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao buscar ID do advogado por ID de usuário", e);
        }
        return -1;
    }
    
   
    public List<String> listarEspecialidades() {
        List<String> especialidades = new ArrayList<>();
        String sql = "SELECT DISTINCT especialidade FROM advogados WHERE especialidade IS NOT NULL AND especialidade != '' ORDER BY especialidade";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                especialidades.add(rs.getString("especialidade"));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao listar especialidades", e);
        }
        return especialidades;
    }

   
    public List<Advogado> listarPorEspecialidade(String especialidade) {
        List<Advogado> advogados = new ArrayList<>();
        String sql = "SELECT u.id_usuario, u.nome, a.id_advogado, a.oab, a.especialidade " +
                     "FROM usuarios u INNER JOIN advogados a ON u.id_usuario = a.id_usuario " +
                     "WHERE a.especialidade = ? AND u.ativo = 'S' ORDER BY u.nome";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, especialidade);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Advogado adv = new Advogado();
                    adv.setId(rs.getInt("id_usuario"));
                    adv.setIdAdvogado(rs.getInt("id_advogado"));
                    adv.setNome(rs.getString("nome"));
                    adv.setOab(rs.getString("oab"));
                    adv.setEspecialidade(rs.getString("especialidade"));
                    advogados.add(adv);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao listar advogados por especialidade", e);
        }
        return advogados;
    }
}
