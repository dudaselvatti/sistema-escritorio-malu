<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Meus Agendamentos - Escritório MaLu</title>
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
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/cliente/painelcliente.jsp">Meu Painel</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">Sair</a></li>
            </ul>
        </div>
    </div>
</nav>
<div class="container my-4 my-md-5">
    <div class="card form-container-card">
        
        <div class="card-header bg-white py-3">
            <div class="d-flex justify-content-between align-items-center">
                <h3 class="mb-0 page-title"><i class="bi bi-calendar-check me-2"></i>Meus Agendamentos</h3>
                <a href="agendamento?action=formNovo" class="btn btn-primary">
                    <i class="bi bi-plus-circle me-1"></i> Solicitar Novo Agendamento
                </a>
            </div>
        </div>

        <div class="card-body p-4">
            
            <c:if test="${not empty sessionScope.mensagemSucesso}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i>
                    ${sessionScope.mensagemSucesso}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="mensagemSucesso" scope="session" />
            </c:if>
            <c:if test="${not empty sessionScope.mensagemErro}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-x-octagon-fill me-2"></i>
                    ${sessionScope.mensagemErro}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="mensagemErro" scope="session" />
            </c:if>

            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>Advogado</th>
                            <th>Data</th>
                            <th>Hora</th>
                            <th>Status</th>
                            <th class="text-center">Ação</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ag" items="${listaAgendamentos}">
                            <tr>
                                <td><c:out value="${ag.nomeAdvogado}" /></td>
                               
                                <td>${String.format("%02d", ag.data.dayOfMonth)}/${String.format("%02d", ag.data.monthValue)}/${ag.data.year}</td>
                                <td><c:out value="${ag.hora}"/></td>
                                <td class="text-capitalize">
                                    <c:choose>
                                        <c:when test="${ag.status == 'agendado'}"><span class="badge bg-primary"><i class="bi bi-clock-history me-1"></i> Agendado</span></c:when>
                                        <c:when test="${ag.status == 'concluído'}"><span class="badge bg-success"><i class="bi bi-check2-circle me-1"></i> Concluído</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary"><i class="bi bi-x-circle me-1"></i> ${ag.status}</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center">
                                    <c:if test="${ag.status == 'agendado'}">
                                        <a href="agendamento?action=cancelar&id=${ag.idAgendamento}" class="btn btn-outline-danger btn-sm" data-bs-toggle="tooltip" data-bs-placement="top" title="Cancelar Agendamento" onclick="return confirm('Tem certeza que deseja cancelar este agendamento?');">
                                            <i class="bi bi-x-circle"></i>
                                        </a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty listaAgendamentos}">
                            <tr>
                                <td colspan="5">
                                    <div class="text-center py-5">
                                        <i class="bi bi-calendar-x fs-1 text-muted"></i>
                                        <h5 class="mt-3">Nenhum Agendamento Encontrado</h5>
                                        <p class="text-muted">Você ainda não possui agendamentos. Clique em "Solicitar Novo Agendamento" para começar.</p>
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
        
        <div class="card-footer bg-white text-end">
             <a href="${pageContext.request.contextPath}/cliente/painelcliente.jsp" class="btn btn-outline-secondary">
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