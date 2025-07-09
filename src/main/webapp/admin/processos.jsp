<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Gerenciamento de Processos - Escritório MaLu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://cdn.datatables.net/2.0.8/css/dataTables.bootstrap5.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
</head>
<body class="d-flex flex-column min-vh-100">

<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">Escritório MaLu</a>
        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/paineladmin.jsp">Meu Painel</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">Sair</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container my-4 my-md-5">
    <div class="card form-container-card">
        <div class="card-header bg-white py-3">
            <h3 class="mb-0 page-title"><i class="bi bi-folder2-open me-2"></i><c:out value="${tituloPagina}" /></h3>
            <p class="text-muted mb-0 mt-1">Visualize e filtre todos os processos jurídicos do sistema.</p>
        </div>
        <div class="card-body p-4">
            <div class="table-responsive">
                <table id="tabelaProcessos" class="table table-hover align-middle" style="width:100%">
                    <thead class="table-light">
                        <tr>
                            <th>Nº Processo</th>
                            <th>Cliente</th>
                            <th>Advogado Responsável</th>
                            <th>Status</th>
                            <th class="text-center">Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="proc" items="${listaProcessos}">
                            <tr>
                                <td><strong>#${proc.idProcesso}</strong></td>
                                <td><c:out value="${proc.nomeCliente}" /></td>
                                <td><c:out value="${proc.nomeAdvogado}" /></td>
                                <td>
                                     <c:choose>
                                        <c:when test="${proc.status == 'concluído'}"><span class="badge bg-success text-capitalize"><i class="bi bi-check-circle me-1"></i> ${proc.status}</span></c:when>
                                        <c:when test="${proc.status == 'cancelado'}"><span class="badge bg-danger text-capitalize"><i class="bi bi-x-circle me-1"></i> ${proc.status}</span></c:when>
                                        <c:otherwise><span class="badge bg-primary text-capitalize"><i class="bi bi-hourglass-split me-1"></i> ${proc.status}</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center">
                                    <button type="button" class="btn btn-outline-primary btn-sm btn-detalhes" 
                                            data-id="${proc.idProcesso}" data-bs-toggle="modal" data-bs-target="#detalhesModal"
                                            title="Ver Detalhes do Processo">
                                        <i class="bi bi-eye-fill"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="card-footer bg-white text-end">
             <a href="${pageContext.request.contextPath}/admin/paineladmin.jsp" class="btn btn-outline-secondary"><i class="bi bi-arrow-left me-1"></i> Voltar ao Painel</a>
        </div>
    </div>
</div>


<div class="modal fade" id="detalhesModal" tabindex="-1" aria-labelledby="modalTitle" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="modalTitle">Detalhes do Processo</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div id="modal-content-body">
            <p><strong>Nº do Processo:</strong> <span id="modal-id"></span></p>
            <p><strong>Cliente:</strong> <span id="modal-cliente"></span></p>
            <p><strong>Advogado Responsável:</strong> <span id="modal-advogado"></span></p>
            <p><strong>Status:</strong> <span id="modal-status" class="text-capitalize"></span></p>
            <hr>
            <p><strong>Descrição:</strong></p>
            <div id="modal-descricao" class="p-2 bg-light border rounded" style="min-height: 100px;"></div>
        </div>
        <div id="modal-loading" class="text-center p-5" style="display: none;">
            <div class="spinner-border text-primary" role="status"><span class="visually-hidden">Carregando...</span></div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fechar</button>
      </div>
    </div>
  </div>
</div>

<footer class="py-4 bg-dark text-white mt-auto">...</footer>

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script src="https://cdn.datatables.net/2.0.8/js/dataTables.js"></script>
<script src="https://cdn.datatables.net/2.0.8/js/dataTables.bootstrap5.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    $(document).ready(function() {
        $('#tabelaProcessos').DataTable({
            "language": {
                "sEmptyTable": "Nenhum registro encontrado",
                "sInfo": "Mostrando de _START_ até _END_ de _TOTAL_ registros",
                "sInfoEmpty": "Mostrando 0 até 0 de 0 registros",
                "sInfoFiltered": "(Filtrados de _MAX_ registros no total)",
                "sInfoPostFix": "",
                "sInfoThousands": ".",
                "sLengthMenu": "Mostrar _MENU_ registros",
                "sProcessing": "Processando...",
                "sZeroRecords": "Nenhum registro encontrado",
                "sSearch": "Pesquisar:",
                "oPaginate": {
                    "sNext": "Próximo",
                    "sPrevious": "Anterior",
                    "sFirst": "Primeiro",
                    "sLast": "Último"
                },
                "oAria": {
                    "sSortAscending": ": Ordenar colunas de forma ascendente",
                    "sSortDescending": ": Ordenar colunas de forma descendente"
                }
            }
        });
        
        var detalhesModal = document.getElementById('detalhesModal');
        detalhesModal.addEventListener('show.bs.modal', function (event) {
            var button = event.relatedTarget;
            var id = button.getAttribute('data-id');
            var modalBody = $('#modal-content-body');
            var modalLoading = $('#modal-loading');
            
            modalBody.hide();
            modalLoading.show();

            $.get('processo?action=getDetalhes&id=' + id, function(processo) {
                if (processo) {
                    $('#modal-id').text('#' + processo.idProcesso);
                    $('#modal-cliente').text(processo.nomeCliente);
                    $('#modal-advogado').text(processo.nomeAdvogado);
                    $('#modal-status').text(processo.status);
                    $('#modal-descricao').text(processo.descricao);
                }
                modalLoading.hide();
                modalBody.show();
            });
        });

        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
          return new bootstrap.Tooltip(tooltipTriggerEl)
        });
    });
</script>
</body>
</html>
