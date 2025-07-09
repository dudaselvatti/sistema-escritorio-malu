<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Painel Administrativo - Escritório MaLu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark shadow-sm" style="background-color: #1A3B5D;">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">Escritório MaLu</a>
        <span class="navbar-text text-white-50 d-none d-lg-block">
            Painel Administrativo
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
        <h1 class="display-5 fw-bold page-title">Painel de Controle</h1>
        <p class="lead text-muted">Escolha uma das opções abaixo para gerenciar os dados do sistema.</p>
    </div>

    <div class="row g-4 justify-content-center">

        <div class="col-md-6 col-lg-4">
            <div class="card card-opcao shadow-sm h-100 text-center">
                <div class="card-body d-flex flex-column">
                    <div class="card-icon mb-3"><i class="bi bi-person-gear"></i></div>
                    <h5 class="card-title">Usuários</h5>
                    <p class="card-text text-muted">Gerencie todos os tipos de usuários do sistema.</p>
                    <a href="${pageContext.request.contextPath}/admin/usuario?action=listar" class="btn btn-primary w-100 rounded-pill mt-auto">Gerenciar</a>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="card card-opcao shadow-sm h-100 text-center">
                <div class="card-body d-flex flex-column">
                    <div class="card-icon mb-3"><i class="bi bi-person-vcard"></i></div>
                    <h5 class="card-title">Pré-cadastro CPF</h5>
                    <p class="card-text text-muted">Controle de CPFs de advogados pré-cadastrados.</p>
                    <a href="${pageContext.request.contextPath}/admin/precadastro" class="btn btn-primary w-100 rounded-pill mt-auto">Gerenciar</a>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="card card-opcao shadow-sm h-100 text-center">
                <div class="card-body d-flex flex-column">
                    <div class="card-icon mb-3"><i class="bi bi-people-fill"></i></div>
                    <h5 class="card-title">Clientes</h5>
                    <p class="card-text text-muted">Visualize e gerencie todos os clientes do escritório.</p>
                    <a href="${pageContext.request.contextPath}/admin/cliente" class="btn btn-primary w-100 rounded-pill mt-auto">Gerenciar</a>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="card card-opcao shadow-sm h-100 text-center">
                <div class="card-body d-flex flex-column">
                    <div class="card-icon mb-3"><i class="bi bi-briefcase-fill"></i></div>
                    <h5 class="card-title">Advogados</h5>
                    <p class="card-text text-muted">Visualize e gerencie todos os advogados do escritório.</p>
                    <a href="${pageContext.request.contextPath}/admin/advogado?action=listar" class="btn btn-primary w-100 rounded-pill mt-auto">Gerenciar</a>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="card card-opcao shadow-sm h-100 text-center">
                <div class="card-body d-flex flex-column">
                    <div class="card-icon mb-3"><i class="bi bi-calendar-week"></i></div>
                    <h5 class="card-title">Agendamentos</h5>
                    <p class="card-text text-muted">Acompanhe todos os agendamentos do sistema.</p>
                    <a href="${pageContext.request.contextPath}/admin/agendamento" class="btn btn-primary w-100 rounded-pill mt-auto">Gerenciar</a>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="card card-opcao shadow-sm h-100 text-center">
                <div class="card-body d-flex flex-column">
                    <div class="card-icon mb-3"><i class="bi bi-folder2-open"></i></div>
                    <h5 class="card-title">Processos</h5>
                    <p class="card-text text-muted">Visualize e controle todos os processos jurídicos.</p>
                    <a href="${pageContext.request.contextPath}/admin/processo" class="btn btn-primary w-100 rounded-pill mt-auto">Gerenciar</a>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="card card-opcao shadow-sm h-100 text-center">
                <div class="card-body d-flex flex-column">
                    <div class="card-icon mb-3"><i class="bi bi-tags-fill"></i></div>
                    <h5 class="card-title">Tipos de Documento</h5>
                    <p class="card-text text-muted">Gerencie os tipos de documentos que podem ser solicitados.</p>
                    <a href="${pageContext.request.contextPath}/admin/tipoDocumento" class="btn btn-primary w-100 rounded-pill mt-auto">Gerenciar</a>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="card card-opcao shadow-sm h-100 text-center">
                <div class="card-body d-flex flex-column">
                    <div class="card-icon mb-3"><i class="bi bi-file-earmark-zip-fill"></i></div>
                    <h5 class="card-title">Documentos</h5>
                    <p class="card-text text-muted">Visualize e gerencie os documentos dos clientes.</p>
                    <a href="${pageContext.request.contextPath}/admin/documento" class="btn btn-primary w-100 rounded-pill mt-auto">Gerenciar</a>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="card card-opcao shadow-sm h-100 text-center">
                <div class="card-body d-flex flex-column">
                    <div class="card-icon mb-3"><i class="bi bi-envelope-paper-fill"></i></div>
                    <h5 class="card-title">Solicitações</h5>
                    <p class="card-text text-muted">Controle as solicitações de documentos pendentes.</p>
                    <a href="${pageContext.request.contextPath}/admin/solicitacao" class="btn btn-primary w-100 rounded-pill mt-auto">Gerenciar</a>
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