<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Meu Painel - Escritório MaLu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark shadow-sm" style="background-color: #1A3B5D;">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">Escritório MaLu</a>
        <span class="navbar-text text-white-50 d-none d-lg-block">
            Portal do Cliente
        </span>
        <div class="d-flex align-items-center ms-auto">
            <span class="navbar-text text-white me-3">
                Olá, <c:out value="${sessionScope.usuarioLogado.nome}"/>
            </span>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light">Sair <i class="bi bi-box-arrow-right ms-1"></i></a>
        </div>
    </div>
</nav>
<main class="container mt-5">

    <div class="p-5 mb-5 text-center panel-header">
        <h1 class="display-5 fw-bold page-title">Bem-vindo(a) ao seu painel</h1>
        <p class="lead text-muted">Aqui você pode acompanhar seus processos e solicitações de forma simples e rápida.</p>
    </div>

    <div class="row g-4 justify-content-center">

        <div class="col-md-6 col-lg-4">
            <div class="card card-opcao shadow-sm h-100 text-center">
                <div class="card-body d-flex flex-column">
                    <div class="card-icon mb-3"><i class="bi bi-folder-fill"></i></div>
                    <h5 class="card-title">Meus Processos</h5>
                    <p class="card-text text-muted">Acompanhe o andamento dos seus casos jurídicos.</p>
                    <a href="${pageContext.request.contextPath}/cliente/processo" class="btn btn-primary w-100 rounded-pill mt-auto">Consultar</a>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="card card-opcao shadow-sm h-100 text-center">
                <div class="card-body d-flex flex-column">
                    <div class="card-icon mb-3"><i class="bi bi-file-earmark-text-fill"></i></div>
                    <h5 class="card-title">Documentos Solicitados</h5>
                    <p class="card-text text-muted">Veja os documentos pendentes e envie os arquivos necessários.</p>
                    <a href="${pageContext.request.contextPath}/cliente/solicitacao" class="btn btn-primary w-100 rounded-pill mt-auto">Verificar</a>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="card card-opcao shadow-sm h-100 text-center">
                <div class="card-body d-flex flex-column">
                    <div class="card-icon mb-3"><i class="bi bi-calendar-check-fill"></i></div>
                    <h5 class="card-title">Meus Agendamentos</h5>
                    <p class="card-text text-muted">Consulte sua agenda de reuniões com nossos advogados.</p>
                    <a href="${pageContext.request.contextPath}/cliente/agendamento" class="btn btn-primary w-100 rounded-pill mt-auto">Ver Agenda</a>
                </div>
            </div>
        </div>

    </div>
</main>

<footer class="footer mt-5">
    &copy; 2025 Escritório MaLu - Todos os direitos reservados.
</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script> 
</body>
</html>