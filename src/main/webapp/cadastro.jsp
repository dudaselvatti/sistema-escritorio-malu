<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Cadastro - Escritório MaLu</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
	<link rel="stylesheet" href="css/index.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            color: #333;
        }
        .navbar { background-color: #1A3B5D !important; }
        .navbar-brand, .nav-link { color: #ffffff !important; }
        .nav-link:hover { color: #4A90E2 !important; }

        .form-container-card {
            background-color: #ffffff;
            border-radius: 0.75rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            margin-top: 2rem;
            margin-bottom: 4rem;
        }
        .page-title { color: #1A3B5D; }
        fieldset {
            border: 1px solid #dee2e6 !important;
            border-radius: 0.5rem;
            transition: box-shadow 0.3s ease;
        }
        fieldset:focus-within {
            border-color: #4A90E2;
            box-shadow: 0 0 0 0.25rem rgba(74, 144, 226, 0.25);
        }
        legend { font-weight: 600; color: #1A3B5D; }
        #btnEnviar { padding: 0.75rem 1.5rem; font-weight: 500; }
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
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/index.jsp#inicio">Início</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/index.jsp#sobre">Sobre Nós</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/index.jsp#servicos">Serviços</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/index.jsp#contato">Contatos</a></li>
                <c:if test="${empty sessionScope.usuarioLogado}">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/index.jsp#login">Login</a></li>
                </c:if>
            </ul>
        </div>
    </div>
</nav>
<div class="container my-4" style="max-width: 900px;">
    <div class="card p-4 p-md-5 form-container-card">
        <div class="text-center mb-4">
            <h2 class="page-title">Cadastro de Usuário</h2>
            <p class="text-muted">Complete o formulário para criar sua conta. A verificação do CPF determinará seu tipo de acesso.</p>
        </div>
        
        <c:if test="${not empty erroCadastro}">
            <div class="alert alert-danger" role="alert"><i class="bi bi-exclamation-triangle-fill me-2"></i>${erroCadastro}</div>
        </c:if>

        <form id="frmCadastro" action="${pageContext.request.contextPath}/cadastro" method="POST">
            <fieldset class="border p-3 mb-4">
                <legend class="float-none w-auto px-2 fs-6">Dados de Acesso</legend>
                <div class="row">
                    <div class="col-md-8 mb-3">
                        <label for="nome" class="form-label">Nome Completo:</label>
                        <input type="text" class="form-control" id="nome" name="nome" value="<c:out value='${usuario.nome}'/>" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label for="cpf" class="form-label">CPF:</label>
                        <input type="text" class="form-control" id="cpf" name="cpf" placeholder="000.000.000-00" maxlength="14" required>
                        <div id="msgCpf" class="form-text"></div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-8 mb-3">
                        <label for="email" class="form-label">Email:</label>
                        <input type="email" class="form-control" id="email" name="email" value="<c:out value='${usuario.email}'/>" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label for="senha" class="form-label">Senha:</label>
                        <input type="password" class="form-control" id="senha" name="senha" required>
                    </div>
                </div>
            </fieldset>

            <div id="advogado-fields" style="display: none;">
                <fieldset class="border p-3 mb-4">
                    <legend class="float-none w-auto px-2 fs-6">Informações do Advogado</legend>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="oab" class="form-label">Nº OAB:</label>
                            <input type="text" class="form-control" id="oab" name="oab">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="especialidade" class="form-label">Especialidade Principal:</label>
                            <select id="especialidade" name="especialidade" class="form-select">
                                <option value="Geral">Geral</option>
                                <option value="Civil">Direito Civil</option>
                                <option value="Criminal">Direito Criminal</option>
                                <option value="Trabalhista">Direito Trabalhista</option>
                                <option value="Empresarial">Direito Empresarial</option>
                            </select>
                        </div>
                    </div>
                </fieldset>
            </div>

            <fieldset class="border p-3 mb-4">
                <legend class="float-none w-auto px-2 fs-6">Endereço e Contato</legend>
                <div class="row">
                    <div class="col-md-3 mb-3">
                        <label for="cep" class="form-label">CEP:</label>
                        <input type="text" class="form-control" id="cep" name="cep" value="<c:out value='${usuario.cep}'/>">
                        <div id="msgCep" class="form-text"></div>
                    </div>
                    <div class="col-md-9 mb-3">
                        <label for="endereco" class="form-label">Endereço (Rua, Nº):</label>
                        <input type="text" class="form-control" id="endereco" name="endereco" value="<c:out value='${usuario.endereco}'/>">
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-5 mb-3">
                        <label for="bairro" class="form-label">Bairro:</label>
                        <input type="text" class="form-control" id="bairro" name="bairro" value="<c:out value='${usuario.bairro}'/>">
                    </div>
                    <div class="col-md-5 mb-3">
                        <label for="cidade" class="form-label">Cidade:</label>
                        <input type="text" class="form-control" id="cidade" name="cidade" value="<c:out value='${usuario.cidade}'/>">
                    </div>
                     <div class="col-md-2 mb-3">
                        <label for="uf" class="form-label">UF:</label>
                        <input type="text" class="form-control" id="uf" name="uf" maxlength="2" value="<c:out value='${usuario.uf}'/>">
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="telefone" class="form-label">Telefone:</label>
                        <input type="text" class="form-control" id="telefone" name="telefone" value="<c:out value='${usuario.telefone}'/>">
                    </div>
                </div>
            </fieldset>

            <input type="hidden" id="tipo_usuario" name="tipoUsuario" value="cliente">
            <div class="d-flex justify-content-end">
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline-secondary me-2">Cancelar</a>
                <button type="submit" class="btn btn-primary" id="btnEnviar">Finalizar Cadastro</button>
            </div>
        </form>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script>
$(document).ready(function() {
    var debounceCpf;
    var campoCpf = $('#cpf');
    var msgCpf = $('#msgCpf');
    var campoTipoUsuario = $('#tipo_usuario');
    var advogadoFields = $('#advogado-fields');

    function formatCpf(cpf) {
        let value = cpf.replace(/\D/g, "");
        if (value.length > 11) value = value.slice(0, 11);

        value = value.replace(/(\d{3})(\d)/, "$1.$2");
        value = value.replace(/(\d{3})(\d)/, "$1.$2");
        value = value.replace(/(\d{3})(\d{1,2})$/, "$1-$2");
        return value;
    }

    function verificarCpf(cpf) {
        $.ajax({
            url: '${pageContext.request.contextPath}/verificaCpf',
            type: 'POST',
            data: { cpf: cpf },
            success: function(response) {
                if (response.podeSerAdvogado) {
                    msgCpf.html('<i class="bi bi-check-circle-fill"></i> CPF pré-cadastrado. Por favor, complete seus dados.').removeClass('text-danger text-info').addClass('text-success');
                    campoTipoUsuario.val('advogado');
                    $('#oab').prop('required', true);
                    $('#especialidade').prop('required', true);
                    advogadoFields.slideDown(300);
                } else {
                    msgCpf.html('<i class="bi bi-info-circle-fill"></i> Você será cadastrado como Cliente.').removeClass('text-success text-danger').addClass('text-info');
                    campoTipoUsuario.val('cliente');
                    $('#oab').prop('required', false);
                    $('#especialidade').prop('required', false);
                    advogadoFields.slideUp(300);
                }
            },
            error: function() {
                msgCpf.html('<i class="bi bi-x-circle-fill"></i> Erro ao verificar CPF.').addClass('text-danger');
            }
        });
    }
    
    campoCpf.on("input", function() {
        var rawValue = $(this).val().replace(/\D/g, "");
        $(this).val(formatCpf($(this).val()));
        
        clearTimeout(debounceCpf);
        if (rawValue.length === 11) {
            msgCpf.html('<div class="spinner-border spinner-border-sm" role="status"><span class="visually-hidden">Loading...</span></div> Verificando...').removeClass('text-danger text-success text-info');
            debounceCpf = setTimeout(function() { verificarCpf(rawValue); }, 800);
        } else {
            msgCpf.text('');
            if(advogadoFields.is(':visible')){
                advogadoFields.slideUp(300);
            }
            campoTipoUsuario.val('cliente');
        }
    });

    $('#cep').on('input', function() {
        let cep = $(this).val().replace(/\D/g, '');
        if (cep.length > 8) cep = cep.slice(0, 8);
        cep = cep.replace(/(\d{5})(\d)/, '$1-$2');
        $(this).val(cep);
    });

    $('#cep').on('blur', function() {
        var cep = $(this).val().replace(/\D/g, '');
        if (cep.length === 8) {
            $("#msgCep").html('<div class="spinner-border spinner-border-sm" role="status"></div>');
            $.getJSON("https://viacep.com.br/ws/" + cep + "/json/?callback=?", function(dados) {
                if (!("erro" in dados)) {
                    $("#endereco").val(dados.logradouro);
                    $("#bairro").val(dados.bairro);
                    $("#cidade").val(dados.localidade);
                    $("#uf").val(dados.uf);
                    $("#msgCep").empty();
                    $("#endereco").focus();
                } else {
                    $("#msgCep").text("CEP não encontrado.").addClass("text-danger");
                }
            }).fail(function() {
                 $("#msgCep").text("Erro ao buscar CEP.").addClass("text-danger");
            });
        }
    });
});
</script>
</body>
</html>