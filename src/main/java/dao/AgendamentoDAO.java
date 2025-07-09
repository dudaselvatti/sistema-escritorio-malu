package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import model.Agendamento;
import util.ConnectionFactory;

public class AgendamentoDAO {

    public void cadastrar(Agendamento agendamento) {
        String sql = "INSERT INTO agendamentos (id_cliente, id_advogado, data, hora, descricao, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, agendamento.getIdCliente());
            ps.setInt(2, agendamento.getIdAdvogado());
            ps.setObject(3, agendamento.getData());
            ps.setTime(4, agendamento.getHora());
            ps.setString(5, agendamento.getDescricao());
            ps.setString(6, agendamento.getStatus());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao cadastrar agendamento", e);
        }
    }

    public void atualizar(Agendamento agendamento) {
        String sql = "UPDATE agendamentos SET id_cliente = ?, id_advogado = ?, data = ?, hora = ?, descricao = ?, status = ? WHERE id_agendamento = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, agendamento.getIdCliente());
            ps.setInt(2, agendamento.getIdAdvogado());
            ps.setObject(3, agendamento.getData());
            ps.setTime(4, agendamento.getHora());
            ps.setString(5, agendamento.getDescricao());
            ps.setString(6, agendamento.getStatus());
            ps.setInt(7, agendamento.getIdAgendamento());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao atualizar agendamento", e);
        }
    }

    public void excluir(int idAgendamento) {
        String sql = "DELETE FROM agendamentos WHERE id_agendamento = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAgendamento);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao excluir agendamento", e);
        }
    }

    public Agendamento buscarPorId(int idAgendamento) {
        Agendamento ag = null;
        String sql = "SELECT * FROM agendamentos WHERE id_agendamento = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAgendamento);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ag = new Agendamento();
                    ag.setIdAgendamento(rs.getInt("id_agendamento"));
                    ag.setIdCliente(rs.getInt("id_cliente"));
                    ag.setIdAdvogado(rs.getInt("id_advogado"));
                    ag.setData(rs.getObject("data", LocalDate.class));
                    ag.setHora(rs.getTime("hora"));
                    ag.setDescricao(rs.getString("descricao"));
                    ag.setStatus(rs.getString("status"));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao buscar agendamento por ID", e);
        }
        return ag;
    }
    
    public void alterarStatus(int idAgendamento, String novoStatus) {
        String sql = "UPDATE agendamentos SET status = ? WHERE id_agendamento = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, novoStatus);
            ps.setInt(2, idAgendamento);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao alterar status do agendamento", e);
        }
    }

    public List<Agendamento> listarTodos() {
        return executarConsulta("ORDER BY ag.data DESC, ag.hora DESC", null);
    }

    public List<Agendamento> listarPorAdvogado(int idAdvogado) {
        return executarConsulta("WHERE ag.id_advogado = ? ORDER BY ag.data DESC, ag.hora DESC", idAdvogado);
    }
    
    public List<Agendamento> listarPorCliente(int idCliente) {
        return executarConsulta("WHERE ag.id_cliente = ? ORDER BY ag.data, ag.hora", idCliente);
    }

    public boolean horarioEstaDisponivel(int idAdvogado, LocalDate data, Time hora, int idAgendamentoAIgnorar) {
        String sql = "SELECT COUNT(*) FROM agendamentos WHERE id_advogado = ? AND data = ? AND hora = ? AND status != 'cancelado' AND id_agendamento != ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, idAdvogado);
            ps.setObject(2, data);
            ps.setTime(3, hora);
            ps.setInt(4, idAgendamentoAIgnorar);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao verificar disponibilidade de horário", e);
        }
        return false;
    }
    
    public Set<String> getHorariosOcupados(int idAdvogado, LocalDate data) {
        Set<String> horariosOcupados = new HashSet<>();
        String sql = "SELECT TIME_FORMAT(hora, '%H:%i') AS horario FROM agendamentos WHERE id_advogado = ? AND data = ? AND status != 'cancelado'";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, idAdvogado);
            ps.setObject(2, data);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    horariosOcupados.add(rs.getString("horario"));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao buscar horários ocupados", e);
        }
        return horariosOcupados;
    }

    private List<Agendamento> executarConsulta(String filtro, Integer idParam) {
        List<Agendamento> agendamentos = new ArrayList<>();
        String sql = "SELECT ag.*, cli_user.nome AS nome_cliente, adv_user.nome AS nome_advogado " +
                     "FROM agendamentos ag " +
                     "JOIN clientes c ON ag.id_cliente = c.id_cliente " +
                     "JOIN usuarios cli_user ON c.id_usuario = cli_user.id_usuario " +
                     "JOIN advogados a ON ag.id_advogado = a.id_advogado " +
                     "JOIN usuarios adv_user ON a.id_usuario = adv_user.id_usuario " +
                     (filtro != null ? filtro : "");

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (idParam != null) {
                ps.setInt(1, idParam);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Agendamento ag = new Agendamento();
                    ag.setIdAgendamento(rs.getInt("id_agendamento"));
                    ag.setIdCliente(rs.getInt("id_cliente"));
                    ag.setIdAdvogado(rs.getInt("id_advogado"));
                    ag.setData(rs.getObject("data", LocalDate.class));
                    ag.setHora(rs.getTime("hora"));
                    ag.setDescricao(rs.getString("descricao"));
                    ag.setStatus(rs.getString("status"));
                    ag.setNomeCliente(rs.getString("nome_cliente"));
                    ag.setNomeAdvogado(rs.getString("nome_advogado"));
                    agendamentos.add(ag);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao executar consulta de agendamentos", e);
        }
        return agendamentos;
    }
}
