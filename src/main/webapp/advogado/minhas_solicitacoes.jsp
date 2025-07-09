<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Minhas Solicitações - Escritório MaLu</title>
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
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/advogado/paineladvogado.jsp">Meu Painel</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">Sair</a></li>
            </ul>
        </div>
    </div>
</nav>
<div class="container my-4 my-md-5">
    <div class="card form-container-card">
        
        <div class="card-header bg-white py-3">
            <div class="d-flex justify-content-between align-items-center">
                <h3 class="mb-0 page-title">Minhas Solicitações de Documentos</h3>
                <a href="solicitacao?action=formNovo" class="btn btn-primary">
                    <i class="bi bi-plus-circle me-1"></i> Nova Solicitação
                </a>
            </div>
        </div>

        <div class="card-body">
            
            <c:if test="${not empty sessionScope.mensagemSucesso}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i>
                    ${sessionScope.mensagemSucesso}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="mensagemSucesso" scope="session" />
            </c:if>

            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>Documento Solicitado</th>
                            <th>Cliente</th>
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
                                <td><fmt:formatDate value="${sol.dataCriacao}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td><fmt:formatDate value="${sol.dataLimite}" pattern="dd/MM/yyyy"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${sol.status == 'pendente'}">
                                            <span class="badge bg-warning text-dark text-capitalize"><i class="bi bi-clock-history me-1"></i> ${sol.status}</span>
                                        </c:when>
                                        <c:when test="${sol.status == 'concluído'}">
                                            <span class="badge bg-success text-capitalize"><i class="bi bi-check-circle me-1"></i> ${sol.status}</span>
                                        </c:when>
                                        <c:when test="${sol.status == 'cancelado'}">
                                            <span class="badge bg-danger text-capitalize"><i class="bi bi-x-circle me-1"></i> ${sol.status}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary text-capitalize">${sol.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center">
                                    <c:if test="${sol.status == 'pendente'}">
                                        <a href="solicitacao?action=cancelar&id=${sol.idSolicitacao}" class="btn btn-outline-warning btn-sm" data-bs-toggle="tooltip" data-bs-placement="top" title="Cancelar Solicitação" onclick="return confirm('Tem certeza que deseja cancelar esta solicitação?');">
                                            <i class="bi bi-x-circle"></i>
                                        </a>
                                    </c:if>
                                    <a href="solicitacao?action=excluir&id=${sol.idSolicitacao}" class="btn btn-outline-danger btn-sm" data-bs-toggle="tooltip" data-bs-placement="top" title="Excluir Registro" onclick="return confirm('Isso irá excluir o registro permanentemente. Tem certeza?');">
                                        <i class="bi bi-trash-fill"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty listaSolicitacoes}">
                            <tr>
                                <td colspan="6">
                                    <div class="text-center py-5">
                                        <i class="bi bi-file-earmark-x fs-1 text-muted"></i>
                                        <h5 class="mt-3">Nenhuma Solicitação Encontrada</h5>
                                        <p class="text-muted">Você ainda não possui solicitações de documentos.</p>
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
        
        <div class="card-footer bg-white text-end">
             <a href="${pageContext.request.contextPath}/advogado/paineladvogado.jsp" class="btn btn-outline-secondary">
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
      return new bootstrap.Tooltip(tooltipTriggerEl)
    })
</script>

</body>
</html>