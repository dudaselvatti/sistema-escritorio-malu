package model;

import java.sql.Date;
import java.sql.Timestamp;

public class Solicitacao {
    
    private int idSolicitacao;
    private int idAdvogado;
    private int idCliente;
    private int idTipoDocumento;
    private String descricao;
    private String status;
    private Timestamp dataCriacao;
    private Date dataLimite;
    
    
    private String nomeAdvogado;
    private String nomeCliente;
    private String nomeTipoDocumento;
    
  
    
    public int getIdSolicitacao() { return idSolicitacao; }
    public void setIdSolicitacao(int idSolicitacao) { this.idSolicitacao = idSolicitacao; }
    public int getIdAdvogado() { return idAdvogado; }
    public void setIdAdvogado(int idAdvogado) { this.idAdvogado = idAdvogado; }
    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }
    public int getIdTipoDocumento() { return idTipoDocumento; }
    public void setIdTipoDocumento(int idTipoDocumento) { this.idTipoDocumento = idTipoDocumento; }
    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Timestamp getDataCriacao() { return dataCriacao; }
    public void setDataCriacao(Timestamp dataCriacao) { this.dataCriacao = dataCriacao; }
    public Date getDataLimite() { return dataLimite; }
    public void setDataLimite(Date dataLimite) { this.dataLimite = dataLimite; }
    public String getNomeAdvogado() { return nomeAdvogado; }
    public void setNomeAdvogado(String nomeAdvogado) { this.nomeAdvogado = nomeAdvogado; }
    public String getNomeCliente() { return nomeCliente; }
    public void setNomeCliente(String nomeCliente) { this.nomeCliente = nomeCliente; }
    public String getNomeTipoDocumento() { return nomeTipoDocumento; }
    public void setNomeTipoDocumento(String nomeTipoDocumento) { this.nomeTipoDocumento = nomeTipoDocumento; }
}