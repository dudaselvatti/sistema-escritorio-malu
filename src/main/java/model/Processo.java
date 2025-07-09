package model;


public class Processo {

    private int idProcesso;
    private String descricao;
    private String status;
    
    private int idCliente;
    private String nomeCliente;
    private int idAdvogado;
    private String nomeAdvogado;

   

    public int getIdProcesso() { return idProcesso; }
    public void setIdProcesso(int idProcesso) { this.idProcesso = idProcesso; }
    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }
    public String getNomeCliente() { return nomeCliente; }
    public void setNomeCliente(String nomeCliente) { this.nomeCliente = nomeCliente; }
    public int getIdAdvogado() { return idAdvogado; }
    public void setIdAdvogado(int idAdvogado) { this.idAdvogado = idAdvogado; }
    public String getNomeAdvogado() { return nomeAdvogado; }
    public void setNomeAdvogado(String nomeAdvogado) { this.nomeAdvogado = nomeAdvogado; }
}
