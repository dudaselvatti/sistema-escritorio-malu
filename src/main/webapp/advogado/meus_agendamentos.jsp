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
                <h3 class="mb-0 page-title">Meus Agendamentos</h3>
                <a href="agendamento?action=formNovo" class="btn btn-primary">
                    <i class="bi bi-plus-circle me-1"></i> Novo Agendamento
                </a>
            </div>
        </div>

        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>Cliente</th>
                            <th>Data</th>
                            <th>Hora</th>
                            <th>Status</th>
                            <th class="text-center">Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ag" items="${listaAgendamentos}">
                            <tr>
                                <td><c:out value="${ag.nomeCliente}" /></td>
								<td>${String.format("%02d", ag.data.dayOfMonth)}/${String.format("%02d", ag.data.monthValue)}/${ag.data.year}</td>
                                <td><c:out value="${ag.hora}" /></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${ag.status == 'agendado'}">
                                            <span class="badge bg-primary text-capitalize">${ag.status}</span>
                                        </c:when>
                                        <c:when test="${ag.status == 'cancelado'}">
                                            <span class="badge bg-danger text-capitalize">${ag.status}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary text-capitalize">${ag.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center">
                                    <a href="agendamento?action=editar&id=${ag.idAgendamento}" class="btn btn-outline-primary btn-sm" title="Editar">
                                        <i class="bi bi-pencil-square"></i>
                                    </a>
                                    <c:if test="${ag.status == 'agendado'}">
                                        <a href="agendamento?action=cancelar&id=${ag.idAgendamento}" class="btn btn-outline-danger btn-sm" title="Cancelar" onclick="return confirm('Tem certeza que deseja cancelar este agendamento?');">
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
                                        <p class="text-muted">Você ainda não possui agendamentos. Crie um novo clicando no botão acima.</p>
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
        <p class="mb-0">&copy; ${currentYear} Escritório MaLu. Todos os direitos reservados.</p>
    </div>
</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>