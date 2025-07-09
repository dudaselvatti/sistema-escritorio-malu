<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Gerenciar Tipos de Documento</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
</head>
<body class="d-flex flex-column min-vh-100">

<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
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
            <div class="d-flex justify-content-between align-items-center">
                <h3 class="mb-0 page-title"><i class="bi bi-tags-fill me-2"></i>Tipos de Documento</h3>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#formModal" id="btnNovo">
                    <i class="bi bi-plus-circle me-1"></i> Adicionar Novo
                </button>
            </div>
        </div>
        <div class="card-body p-4">
            <div id="feedback-alert"></div>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>Nome do Tipo de Documento</th>
                            <th class="text-center" style="width: 25%;">Ações</th>
                        </tr>
                    </thead>
                    <tbody id="tabela-tipos-body">
                        <c:forEach var="tipo" items="${listaTipos}">
                            <tr id="row-${tipo.id}">
                                <td class="nome-tipo"><c:out value="${tipo.nome}" /></td>
                                <td class="text-center">
                                    <button type="button" class="btn btn-outline-primary btn-sm btn-editar" data-id="${tipo.id}" title="Editar">
                                        <i class="bi bi-pencil-square"></i>
                                    </button>
                                    <a href="tipoDocumento?action=excluir&id=${tipo.id}" class="btn btn-outline-danger btn-sm btn-excluir" title="Excluir">
                                        <i class="bi bi-trash-fill"></i>
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

<div class="modal fade" id="formModal" tabindex="-1" aria-labelledby="modalTitle" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="modalTitle"></h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form id="tipoDocForm" method="POST">
          <div class="modal-body">
            <div id="modal-feedback"></div>
            <input type="hidden" id="id" name="id">
            <div class="mb-3">
              <label for="nome" class="form-label">Nome do Tipo de Documento:</label>
              <input type="text" class="form-control" id="nome" name="nome" required>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
            <button type="submit" class="btn btn-primary">Salvar</button>
          </div>
      </form>
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
    var modal = new bootstrap.Modal(document.getElementById('formModal'));
    var form = $('#tipoDocForm');
    var feedbackAlert = $('#feedback-alert');
    var modalFeedback = $('#modal-feedback');

    function abrirModal(id) {
        form.trigger('reset');
        modalFeedback.html('');
        form.attr('action', 'tipoDocumento?action=salvar');
        
        if (id) {
            $('#modalTitle').text('Editar Tipo de Documento');
            $.get('tipoDocumento?action=get&id=' + id, function(data) {
                if (data) {
                    form.find('#id').val(data.id);
                    form.find('#nome').val(data.nome);
                    modal.show();
                }
            });
        } else {
            $('#modalTitle').text('Novo Tipo de Documento');
            form.find('#id').val('');
            modal.show();
        }
    }

    $('#btnNovo').on('click', function() { abrirModal(null); });
    $('tbody').on('click', '.btn-editar', function() { abrirModal($(this).data('id')); });

    form.on('submit', function(event) {
        event.preventDefault();
        $.ajax({
            url: form.attr('action'),
            type: 'POST',
            data: form.serialize(),
            dataType: 'json',
            success: function(tipo) {
                var isUpdate = form.find('#id').val() !== '';
                var nome = $('<div>').text(tipo.nome).html();
                
                if (isUpdate) {
                    $('#row-' + tipo.id).find('.nome-tipo').text(nome);
                } else {
                    var newRow = '<tr id="row-' + tipo.id + '"><td class="nome-tipo">' + nome + '</td><td class="text-center">'
                               + '<button type="button" class="btn btn-outline-primary btn-sm btn-editar" data-id="' + tipo.id + '" title="Editar"><i class="bi bi-pencil-square"></i></button> '
                               + '<a href="tipoDocumento?action=excluir&id=' + tipo.id + '" class="btn btn-outline-danger btn-sm btn-excluir" title="Excluir"><i class="bi bi-trash-fill"></i></a>'
                               + '</td></tr>';
                    $('#tabela-tipos-body').prepend(newRow);
                }
                modal.hide();
                showAlert('Operação realizada com sucesso!', 'success');
            },
            error: function(xhr) {
                var errorMsg = xhr.responseJSON ? xhr.responseJSON.erro : 'Ocorreu um erro.';
                modalFeedback.html('<div class="alert alert-danger">' + errorMsg + '</div>');
            }
        });
    });

    $('tbody').on('click', '.btn-excluir', function(event) {
        event.preventDefault();
        if (!confirm('Tem certeza que deseja excluir este tipo de documento?')) return;

        var link = $(this);
        var url = link.attr('href');
        var row = link.closest('tr');

        $.ajax({
            url: url,
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    row.fadeOut(400, function() { $(this).remove(); });
                    showAlert(response.message, 'success');
                }
            },
            error: function(xhr) {
                var errorMsg = xhr.responseJSON ? xhr.responseJSON.message : 'Ocorreu um erro ao excluir.';
                showAlert(errorMsg, 'danger');
            }
        });
    });

    function showAlert(message, type) {
        feedbackAlert.html('<div class="alert alert-' + type + ' alert-dismissible fade show">' + message + '<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>').slideDown().delay(4000).slideUp();
    }
});
</script>
</body>
</html>
