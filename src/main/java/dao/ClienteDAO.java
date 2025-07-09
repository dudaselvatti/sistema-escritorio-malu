package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Cliente; // Importa o modelo Cliente completo
import model.ClienteDTO;
import util.ConnectionFactory;


public class ClienteDAO {


    public List<ClienteDTO> listarParaDropdown() {
        List<ClienteDTO> listaClientes = new ArrayList<>();
        String sql = "SELECT c.id_cliente, u.nome FROM clientes c " +
                     "INNER JOIN usuarios u ON c.id_usuario = u.id_usuario " +
                     "WHERE u.ativo = 'S' AND u.tipo_usuario = 'cliente' ORDER BY u.nome";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ClienteDTO cliente = new ClienteDTO();
                cliente.setIdCliente(rs.getInt("id_cliente"));
                cliente.setNome(rs.getString("nome"));
                listaClientes.add(cliente);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao listar clientes para dropdown", e);
        }
        return listaClientes;
    }
    
 
    public List<Cliente> listarPorAdvogado(int idAdvogado) {
        List<Cliente> listaClientes = new ArrayList<>();
        String sql = "SELECT DISTINCT c.id_cliente, u.id_usuario, u.nome, u.email, u.telefone, u.ativo " +
                     "FROM clientes c " +
                     "JOIN usuarios u ON c.id_usuario = u.id_usuario " +
                     "JOIN processos p ON c.id_cliente = p.id_cliente " +
                     "WHERE p.id_advogado = ? ORDER BY u.nome";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, idAdvogado);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Cliente cliente = new Cliente();
                    cliente.setId(rs.getInt("id_usuario"));
                    cliente.setIdCliente(rs.getInt("id_cliente"));
                    cliente.setNome(rs.getString("nome"));
                    cliente.setEmail(rs.getString("email"));
                    cliente.setTelefone(rs.getString("telefone"));
                    cliente.setAtivo(rs.getString("ativo"));
                    listaClientes.add(cliente);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao listar clientes por advogado", e);
        }
        return listaClientes;
    }
    

    public List<Cliente> listarTodosCompletos() {
        List<Cliente> listaClientes = new ArrayList<>();
        String sql = "SELECT c.id_cliente, u.id_usuario, u.nome, u.email, u.telefone, u.ativo " +
                     "FROM clientes c " +
                     "JOIN usuarios u ON c.id_usuario = u.id_usuario " +
                     "WHERE u.tipo_usuario = 'cliente' ORDER BY u.nome";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Cliente cliente = new Cliente();
                cliente.setId(rs.getInt("id_usuario"));
                cliente.setIdCliente(rs.getInt("id_cliente"));
                cliente.setNome(rs.getString("nome"));
                cliente.setEmail(rs.getString("email"));
                cliente.setTelefone(rs.getString("telefone"));
                cliente.setAtivo(rs.getString("ativo"));
                listaClientes.add(cliente);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao listar todos os clientes", e);
        }
        return listaClientes;
    }
    

    public int buscarIdClientePorIdUsuario(int idUsuario) {
        String sql = "SELECT id_cliente FROM clientes WHERE id_usuario = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id_cliente");
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao buscar ID do cliente", e);
        }
        return -1; 
    }
}
