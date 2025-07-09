<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Gerenciamento de Pré-Cadastro - Escritório MaLu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
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
<div class="container my-4 my-md-5">
    <div class="card form-container-card">
        <div class="card-header bg-white py-3">
            <h3 class="mb-0 page-title"><i class="bi bi-person-vcard me-2"></i>CPFs Pré-Cadastrados para Advogados</h3>
            <p class="text-muted mb-0 mt-1">Adicione os CPFs que terão permissão para se cadastrar como "Advogado".</p>
        </div>
        <div class="card-body p-4">
            <div class="row">
                <div class="col-lg-5 mb-4 mb-lg-0">
                    <div class="card bg-light border h-100">
                        <div class="card-body">
                            <h5 class="card-title mb-3">Adicionar Novo CPF</h5>
                            <form id="formPrecadastro" action="precadastro?action=inserir" method="POST">
                                <div class="mb-2">
                                    <label for="cpf" class="form-label">CPF do Advogado:</label>
                                    <input type="text" class="form-control" id="cpf" name="cpf" placeholder="000.000.000-00" required>
                                </div>
                                <button type="submit" class="btn btn-primary w-100 mt-2"><i class="bi bi-plus-circle me-1"></i> Adicionar</button>
                            </form>
                            <div id="feedback-message" class="mt-3"></div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-7">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>CPF Cadastrado</th>
                                    <th class="text-center" style="width: 15%;">Ação</th>
                                </tr>
                            </thead>
                            <tbody id="tabela-cpfs-body">
                                <c:forEach var="pc" items="${listaPrecadastro}">
                                    <tr>
                                        <td><c:out value="${pc.cpf}" /></td>
                                        <td class="text-center">
                                            <a href="precadastro?action=excluir&id=${pc.id}" class="btn btn-outline-danger btn-sm" data-bs-toggle="tooltip" data-bs-placement="top" title="Excluir" onclick="return confirm('Tem certeza que deseja excluir este CPF?');">
                                                <i class="bi bi-trash-fill"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty listaPrecadastro}"><tr class="empty-row"><td colspan="2"><div class="text-center py-4 text-muted"><i class="bi bi-search fs-2"></i><p class="mb-0 mt-2">Nenhum CPF pré-cadastrado.</p></div></td></tr></c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="card-footer bg-white text-end">
             <a href="${pageContext.request.contextPath}/admin/paineladmin.jsp" class="btn btn-outline-secondary"><i class="bi bi-arrow-left me-1"></i> Voltar ao Painel</a>
        </div>
    </div>
</div>
<footer class="py-4 bg-dark text-white mt-auto">
    <div class="container text-center"><p class="mb-0">&copy; 2025 Escritório MaLu. Todos os direitos reservados.</p></div>
</footer>

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
$(document).ready(function() {
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
      return new bootstrap.Tooltip(tooltipTriggerEl);
    });

    $('#cpf').on('input', function() {
        var value = $(this).val().replace(/\D/g, '');
        if (value.length > 11) value = value.slice(0, 11);
        value = value.replace(/(\d{3})(\d)/, '$1.$2').replace(/(\d{3})(\d)/, '$1.$2').replace(/(\d{3})(\d{1,2})$/, '$1-$2');
        $(this).val(value);
    });

    $('#formPrecadastro').on('submit', function(event) {
        event.preventDefault(); 

        var form = $(this);
        var cpfInput = form.find('input[name="cpf"]');
        var feedbackDiv = $('#feedback-message');
        var tbody = $('#tabela-cpfs-body');
        
        var cpfComMascara = cpfInput.val();
        var cpfLimpo = cpfComMascara.replace(/\D/g, ''); 

        feedbackDiv.html(''); 

        $.ajax({
            url: form.attr('action'),
            type: 'POST',
            data: { cpf: cpfLimpo }, 
            dataType: 'json',
            success: function(response) {
                feedbackDiv.html('<div class="alert alert-success alert-dismissible fade show" role="alert">' + response.message + '<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>');
                tbody.find('.empty-row').remove();
                
                
                var newRow = '<tr><td>' + cpfComMascara + '</td><td class="text-center"><span class="badge bg-secondary">Recarregue para gerenciar</span></td></tr>';
                tbody.prepend(newRow);
                cpfInput.val('');
            },
            error: function(xhr) {
                var errorMsg = (xhr.responseJSON && xhr.responseJSON.message) ? xhr.responseJSON.message : 'Ocorreu um erro.';
                feedbackDiv.html('<div class="alert alert-danger alert-dismissible fade show" role="alert">' + errorMsg + '<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>');
            }
        });
    });
});
</script>
</body>
</html>