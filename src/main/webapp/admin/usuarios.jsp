<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Gerenciamento de Usuários - Escritório MaLu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
    <style>
        #feedback-alert-container {
            position: fixed;
            top: 80px;
            right: 20px;
            z-index: 1050;
            min-width: 300px;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">Escritório MaLu</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/paineladmin.jsp">Meu Painel</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">Sair</a></li>
            </ul>
        </div>
    </div>
</nav>
<div id="feedback-alert-container">
    <div id="feedback-alert" style="display: none;"></div>
</div>

<div class="container my-4 my-md-5">
    <div class="card form-container-card">
        
        <div class="card-header bg-white py-3">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h3 class="mb-0 page-title">Gerenciar Usuários</h3>
                    <p class="text-muted mb-0 mt-1">Controle todos os usuários do sistema.</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/usuario?action=formNovo" class="btn btn-primary">
                    <i class="bi bi-person-plus-fill me-1"></i> Novo Usuário
                </a>
            </div>
        </div>

        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Nome</th>
                            <th>Email</th>
                            <th>Tipo</th>
                            <th>Status</th>
                            <th class="text-center">Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${listaUsuarios}">
                            <tr id="usuario-row-${u.id}">
                                <td><strong>#${u.id}</strong></td>
                                <td><c:out value="${u.nome}" /></td>
                                <td><c:out value="${u.email}" /></td>
                                <td class="text-capitalize"><c:out value="${u.tipoUsuario}" /></td>
                                <td>
                                    <span id="status-badge-${u.id}" class="badge ${u.ativo == 'S' ? 'bg-success' : 'bg-danger'}">
                                        <i class="bi ${u.ativo == 'S' ? 'bi-check-circle' : 'bi-x-circle'} me-1"></i>
                                        ${u.ativo == 'S' ? 'Ativo' : 'Inativo'}
                                    </span>
                                </td>
                                <td class="text-center">
                                    <a href="usuario?action=editar&id=${u.id}" class="btn btn-outline-primary btn-sm" data-bs-toggle="tooltip" data-bs-placement="top" title="Editar Usuário">
                                        <i class="bi bi-pencil-square"></i>
                                    </a>
                                    
									<a href="${pageContext.request.contextPath}/admin/usuario?action=alterarStatus&id=${u.id}&statusAtual=${u.ativo}"                                       class="btn btn-sm btn-alterar-status ${u.ativo == 'S' ? 'btn-outline-warning' : 'btn-outline-success'}"
                                       data-bs-toggle="tooltip" data-bs-placement="top" title="${u.ativo == 'S' ? 'Desativar' : 'Ativar'}">
                                        <i class="bi ${u.ativo == 'S' ? 'bi-toggle-off' : 'bi-toggle-on'}"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
        
        <div class="card-footer bg-white text-end">
             <a href="${pageContext.request.contextPath}/admin/paineladmin.jsp" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-1"></i> Voltar ao Painel
            </a>
        </div>
    </div>
</div>

<footer class="py-4 bg-dark text-white mt-auto">
    <div class="container text-center">
        <p class="mb-0">&copy; 2025 Escritório MaLu. Todos os direitos reservados.</p>
    </div>
</footer>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
$(document).ready(function() {
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
      return new bootstrap.Tooltip(tooltipTriggerEl)
    });

    $('tbody').on('click', '.btn-alterar-status', function(event) {
        event.preventDefault(); 

        var link = $(this);
        var url = link.attr('href');
        var isDeactivating = link.attr('href').includes('statusAtual=S');
        
        var confirmMessage = isDeactivating
            ? 'Tem certeza que deseja DESATIVAR este usuário?' 
            : 'Tem certeza que deseja ATIVAR este usuário?';

        if (!confirm(confirmMessage)) {
            return;
        }

        $.ajax({
            url: url,
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    var idUsuario = new URL(url, window.location.origin).searchParams.get("id");
                    var statusBadge = $('#status-badge-' + idUsuario);
                    
                    if (response.novoStatus === 'S') {
                        statusBadge.removeClass('bg-danger').addClass('bg-success').html('<i class="bi bi-check-circle me-1"></i> Ativo');
                        link.removeClass('btn-outline-success').addClass('btn-outline-warning').attr('title', 'Desativar');
                        link.find('i').removeClass('bi-toggle-on').addClass('bi-toggle-off');
                        link.attr('href', 'usuario?action=alterarStatus&id=' + idUsuario + '&statusAtual=S');
                    } else {
                        statusBadge.removeClass('bg-success').addClass('bg-danger').html('<i class="bi bi-x-circle me-1"></i> Inativo');
                        link.removeClass('btn-outline-warning').addClass('btn-outline-success').attr('title', 'Ativar');
                        link.find('i').removeClass('bi-toggle-off').addClass('bi-toggle-on');
                        link.attr('href', 'usuario?action=alterarStatus&id=' + idUsuario + '&statusAtual=N');
                    }
                    
                    var tooltip = bootstrap.Tooltip.getInstance(link);
                    if (tooltip) {
                        tooltip.dispose(); 
                    }
                    new bootstrap.Tooltip(link);

                    $('#feedback-alert').html('<div class="alert alert-success alert-dismissible fade show" role="alert">' + response.message + '<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>').slideDown().delay(4000).slideUp();
                }
            },
            error: function(xhr) {
                var errorMsg = xhr.responseJSON ? xhr.responseJSON.message : 'Ocorreu um erro.';
                 $('#feedback-alert').html('<div class="alert alert-danger alert-dismissible fade show" role="alert">' + errorMsg + '<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>').slideDown().delay(4000).slideUp();
            }
        });
    });
});
</script>
</body>
</html>