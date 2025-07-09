package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.Advogado;
import model.Cliente;
import model.Usuario;
import util.ConnectionFactory;

public class UsuarioDAO {


    public Usuario autenticar(String email, String senha) {
        String sql = "SELECT u.*, a.id_advogado, a.oab, a.especialidade, c.id_cliente " +
                     "FROM usuarios u " +
                     "LEFT JOIN advogados a ON u.id_usuario = a.id_usuario " +
                     "LEFT JOIN clientes c ON u.id_usuario = c.id_usuario " +
                     "WHERE u.email = ? AND u.senha = ? AND u.ativo = 'S'";
        
        Usuario usuario = null;
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, senha);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String tipoUsuario = rs.getString("tipo_usuario");
                    if ("advogado".equalsIgnoreCase(tipoUsuario)) {
                        Advogado adv = new Advogado();
                        popularUsuarioBase(adv, rs);
                        adv.setIdAdvogado(rs.getInt("id_advogado"));
                        adv.setOab(rs.getString("oab"));
                        adv.setEspecialidade(rs.getString("especialidade"));
                        usuario = adv;
                    } else if ("cliente".equalsIgnoreCase(tipoUsuario)) {
                        Cliente cli = new Cliente();
                        popularUsuarioBase(cli, rs);
                        cli.setIdCliente(rs.getInt("id_cliente"));
                        usuario = cli;
                    } else {
                        usuario = new Usuario();
                        popularUsuarioBase(usuario, rs);
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao autenticar usuário", e);
        }
        return usuario;
    }
    
    public Usuario buscarPorEmail(String email) {
        String sql = "SELECT * FROM usuarios WHERE email = ?";
        Usuario u = null;
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    u = new Usuario();
                    popularUsuarioBase(u, rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao buscar usuário por email", e);
        }
        return u;
    }


    public void cadastrar(Usuario usuario) {
        String sqlUsuario = "INSERT INTO usuarios (nome, email, senha, cpf, endereco, bairro, cidade, uf, cep, telefone, tipo_usuario, ativo) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String sqlPapel = "";
        Connection conn = null;

        try {
            conn = ConnectionFactory.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement psUsuario = conn.prepareStatement(sqlUsuario, Statement.RETURN_GENERATED_KEYS)) {
                psUsuario.setString(1, usuario.getNome());
                psUsuario.setString(2, usuario.getEmail());
                psUsuario.setString(3, usuario.getSenha());
                psUsuario.setString(4, usuario.getCpf());
                psUsuario.setString(5, usuario.getEndereco());
                psUsuario.setString(6, usuario.getBairro());
                psUsuario.setString(7, usuario.getCidade());
                psUsuario.setString(8, usuario.getUf());
                psUsuario.setString(9, usuario.getCep());
                psUsuario.setString(10, usuario.getTelefone());
                psUsuario.setString(11, usuario.getTipoUsuario());
                psUsuario.setString(12, usuario.getAtivo());
                psUsuario.executeUpdate();

                try (ResultSet generatedKeys = psUsuario.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        usuario.setId(generatedKeys.getInt(1));
                    } else {
                        throw new SQLException("Falha ao obter o ID do usuário.");
                    }
                }
            }

            switch (usuario.getTipoUsuario().toLowerCase()) {
                case "cliente":
                    sqlPapel = "INSERT INTO clientes (id_usuario) VALUES (?)";
                    break;
                case "advogado":
                    sqlPapel = "INSERT INTO advogados (id_usuario, oab, especialidade) VALUES (?, ?, ?)";
                    break;
                case "administrador":
                    sqlPapel = "INSERT INTO administradores (id_usuario) VALUES (?)";
                    break;
            }

            try (PreparedStatement psPapel = conn.prepareStatement(sqlPapel)) {
                psPapel.setInt(1, usuario.getId());
                if (usuario instanceof Advogado) {
                    Advogado adv = (Advogado) usuario;
                    psPapel.setString(2, adv.getOab());
                    psPapel.setString(3, adv.getEspecialidade());
                }
                psPapel.executeUpdate();
            }

            conn.commit();

        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            if (e.getErrorCode() == 1062) {
                throw new RuntimeException("O CPF ou E-mail informado já está cadastrado no sistema.");
            }
            throw new RuntimeException("Erro ao cadastrar usuário no banco de dados", e);
        } finally {
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
    

    public void atualizar(Usuario usuario) {
        String sql = "UPDATE usuarios SET nome=?, email=?, cpf=?, endereco=?, bairro=?, cidade=?, uf=?, cep=?, telefone=?, ativo=? WHERE id_usuario=?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, usuario.getNome());
            ps.setString(2, usuario.getEmail());
            ps.setString(3, usuario.getCpf());
            ps.setString(4, usuario.getEndereco());
            ps.setString(5, usuario.getBairro());
            ps.setString(6, usuario.getCidade());
            ps.setString(7, usuario.getUf());
            ps.setString(8, usuario.getCep());
            ps.setString(9, usuario.getTelefone());
            ps.setString(10, usuario.getAtivo());
            ps.setInt(11, usuario.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao atualizar usuário", e);
        }
    }


    public List<Usuario> listar() {
        List<Usuario> usuarios = new ArrayList<>();
        String sql = "SELECT * FROM usuarios ORDER BY nome";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Usuario u = new Usuario();
                popularUsuarioBase(u, rs);
                usuarios.add(u);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao listar usuários", e);
        }
        return usuarios;
    }


    public Usuario buscarPorId(int id) {
        Usuario u = null;
        String sql = "SELECT * FROM usuarios WHERE id_usuario = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    u = new Usuario();
                    popularUsuarioBase(u, rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao buscar usuário por ID", e);
        }
        return u;
    }


    public void alterarStatus(int idUsuario, String novoStatus) {
        String sql = "UPDATE usuarios SET ativo = ? WHERE id_usuario = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, novoStatus);
            ps.setInt(2, idUsuario);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao alterar o status do usuário", e);
        }
    }


    private void popularUsuarioBase(Usuario u, ResultSet rs) throws SQLException {
        u.setId(rs.getInt("id_usuario"));
        u.setNome(rs.getString("nome"));
        u.setEmail(rs.getString("email"));
        u.setCpf(rs.getString("cpf"));
        u.setEndereco(rs.getString("endereco"));
        u.setBairro(rs.getString("bairro"));
        u.setCidade(rs.getString("cidade"));
        u.setUf(rs.getString("uf"));
        u.setCep(rs.getString("cep"));
        u.setTelefone(rs.getString("telefone"));
        u.setTipoUsuario(rs.getString("tipo_usuario"));
        u.setAtivo(rs.getString("ativo"));
        u.setDataCadastro(rs.getTimestamp("data_cadastro"));
    }
}
