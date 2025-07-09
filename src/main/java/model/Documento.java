package model;

import java.sql.Timestamp;

public class Documento {
    
    private int id;
    private int idCliente;
    private int idTipoDocumento;
    private String titulo;
    private String descricao;
    private String caminhoArquivo; 
    private Timestamp dataUpload;
    
    
    private String nomeCliente;
    private String nomeTipoDocumento;

   

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }
    public int getIdTipoDocumento() { return idTipoDocumento; }
    public void setIdTipoDocumento(int idTipoDocumento) { this.idTipoDocumento = idTipoDocumento; }
    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }
    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }
    public String getCaminhoArquivo() { return caminhoArquivo; }
    public void setCaminhoArquivo(String caminhoArquivo) { this.caminhoArquivo = caminhoArquivo; }
    public Timestamp getDataUpload() { return dataUpload; }
    public void setDataUpload(Timestamp dataUpload) { this.dataUpload = dataUpload; }
    public String getNomeCliente() { return nomeCliente; }
    public void setNomeCliente(String nomeCliente) { this.nomeCliente = nomeCliente; }
    public String getNomeTipoDocumento() { return nomeTipoDocumento; }
    public void setNomeTipoDocumento(String nomeTipoDocumento) { this.nomeTipoDocumento = nomeTipoDocumento; }
}
