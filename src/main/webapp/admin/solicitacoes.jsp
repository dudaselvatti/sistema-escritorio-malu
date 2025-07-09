<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Gerenciar Solicitações de Documentos - Escritório MaLu</title>
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
                <h3 class="mb-0 page-title"><i class="bi bi-envelope-paper-fill me-2"></i>Solicitações de Documentos</h3>
                <a href="solicitacao?action=formNovo" class="btn btn-primary">
                    <i class="bi bi-plus-circle me-1"></i> Nova Solicitação
                </a>
            </div>
        </div>

        <div class="card-body p-4">

            <c:if test="${not empty sessionScope.mensagemSucesso}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i>
                    ${sessionScope.mensagemSucesso}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="mensagemSucesso" scope="session" />
            </c:if>
            <c:if test="${not empty sessionScope.mensagemErro}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-x-octagon-fill me-2"></i>
                    ${sessionScope.mensagemErro}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="mensagemErro" scope="session" />
            </c:if>

            <table id="tabelaSolicitacoes" class="table table-hover align-middle" style="width:100%">
                <thead class="table-light">
                    <tr>
                        <th>Documento Solicitado</th>
                        <th>Cliente</th>
                        <th>Advogado Solicitante</th>
                        <th>Data da Solicitação</th>
                        <th>Prazo Final</th>
                        <th>Status</th>
                        <th class="text-center">Ações</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="sol" items="${listaSolicitacoes}">
                        <tr>
                            <td><c:out value="${sol.nomeTipoDocumento}" /></td>
                            <td><c:out value="${sol.nomeCliente}" /></td>
                            <td><c:out value="${sol.nomeAdvogado}" /></td>
                            <td><fmt:formatDate value="${sol.dataCriacao}" pattern="dd/MM/yyyy 'às' HH:mm"/></td>
                            <td><fmt:formatDate value="${sol.dataLimite}" pattern="dd/MM/yyyy"/></td>
                            <td class="text-capitalize">
                                <c:choose>
                                    <c:when test="${sol.status == 'pendente'}"><span class="badge bg-warning text-dark"><i class="bi bi-clock-history me-1"></i> Pendente</span></c:when>
                                    <c:when test="${sol.status == 'concluída'}"><span class="badge bg-success"><i class="bi bi-check2-circle me-1"></i> Concluída</span></c:when>
                                    <c:when test="${sol.status == 'cancelada'}"><span class="badge bg-danger"><i class="bi bi-x-circle me-1"></i> Cancelada</span></c:when>
                                    <c:otherwise><span class="badge bg-secondary">${sol.status}</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <div class="btn-group">
                                    <c:choose>
                                        <c:when test="${sol.status == 'pendente'}">
                                            <a href="solicitacao?action=marcarConcluida&id=${sol.idSolicitacao}" class="btn btn-outline-success btn-sm" data-bs-toggle="tooltip" data-bs-placement="top" title="Marcar como Concluída">
                                                <i class="bi bi-check2-square"></i>
                                            </a>
                                            <a href="solicitacao?action=cancelar&id=${sol.idSolicitacao}" class="btn btn-outline-warning btn-sm" data-bs-toggle="tooltip" data-bs-placement="top" title="Cancelar Solicitação">
                                                <i class="bi bi-x-square"></i>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted fst-italic small p-2">Nenhuma ação</span>
                                        </c:otherwise>
                                    </c:choose>
                                    <a href="solicitacao?action=excluir&id=${sol.idSolicitacao}" class="btn btn-outline-danger btn-sm" data-bs-toggle="tooltip" data-bs-placement="top" title="Excluir Permanentemente" onclick="return confirm('Tem certeza que deseja EXCLUIR PERMANENTEMENTE esta solicitação?');">
                                        <i class="bi bi-trash-fill"></i>
                                    </a>
                                </div>
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
       
        $('#tabelaSolicitacoes').DataTable({
            "language": {
                "sEmptyTable": "Nenhuma solicitação encontrada",
                "sInfo": "Mostrando de _START_ até _END_ de _TOTAL_ solicitações",
                "sInfoEmpty": "Mostrando 0 até 0 de 0 solicitações",
                "sInfoFiltered": "(Filtradas de _MAX_ no total)",
                "sLengthMenu": "Mostrar _MENU_ solicitações",
                "sSearch": "Pesquisar:",
                "oPaginate": { "sNext": "Próximo", "sPrevious": "Anterior" },
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