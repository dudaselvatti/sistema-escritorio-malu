<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Gerenciamento de Documentos - Escritório MaLu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <link href="https://cdn.datatables.net/2.0.8/css/dataTables.bootstrap5.css" rel="stylesheet">

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
            <div class="d-flex justify-content-between align-items-center">
                <h3 class="mb-0 page-title"><i class="bi bi-file-earmark-zip-fill me-2"></i>Gerenciar Documentos</h3>
                <a href="documento?action=formNovo" class="btn btn-primary">
                    <i class="bi bi-plus-circle me-1"></i> Novo Documento
                </a>
            </div>
        </div>

        <div class="card-body p-4">
            <table id="tabelaDocumentos" class="table table-hover align-middle" style="width:100%">
                <thead class="table-light">
                    <tr>
                        <th>Título</th>
                        <th>Tipo</th>
                        <th>Cliente</th>
                        <th>Data de Upload</th>
                        <th class="text-center">Ações</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="doc" items="${listaDocumentos}">
                        <tr>
                            <td><c:out value="${doc.titulo}" /></td>
                            <td><c:out value="${doc.nomeTipoDocumento}" /></td>
                            <td><c:out value="${doc.nomeCliente}" /></td>
                            <td><fmt:formatDate value="${doc.dataUpload}" pattern="dd/MM/yyyy 'às' HH:mm"/></td>
                            <td class="text-center">
                                <a href="documento?action=download&id=${doc.id}" class="btn btn-outline-primary btn-sm" data-bs-toggle="tooltip" data-bs-placement="top" title="Baixar Documento">
                                    <i class="bi bi-download"></i>
                                </a>
                                <a href="documento?action=excluir&id=${doc.id}" class="btn btn-outline-danger btn-sm" data-bs-toggle="tooltip" data-bs-placement="top" title="Excluir Documento" onclick="return confirm('Tem certeza que deseja excluir este documento?');">
                                    <i class="bi bi-trash-fill"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
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
<script src="https://cdn.datatables.net/2.0.8/js/dataTables.js"></script>
<script src="https://cdn.datatables.net/2.0.8/js/dataTables.bootstrap5.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    $(document).ready(function() {
        $('#tabelaDocumentos').DataTable({
            "language": {
                "sEmptyTable": "Nenhum documento encontrado",
                "sInfo": "Mostrando de _START_ até _END_ de _TOTAL_ documentos",
                "sInfoEmpty": "Mostrando 0 até 0 de 0 documentos",
                "sInfoFiltered": "(Filtrados de _MAX_ documentos no total)",
                "sLengthMenu": "Mostrar _MENU_ documentos",
                "sSearch": "Pesquisar:",
                "oPaginate": { "sNext": "Próximo", "sPrevious": "Anterior" }
               
            }
        });

        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
          return new bootstrap.Tooltip(tooltipTriggerEl)
        });
    });
</script>
</body>
</html>