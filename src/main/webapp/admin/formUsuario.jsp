<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${not empty usuario && usuario.id > 0 ? 'Editar' : 'Novo'} Usuário - Escritório MaLu</title>
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
    <div class="card form-container-card mx-auto" style="max-width: 900px;">
        <form action="${pageContext.request.contextPath}/admin/usuario?action=${not empty usuario && usuario.id > 0 ? 'atualizar' : 'inserir'}" method="POST">
            
            <div class="card-header bg-white py-3">
                <h3 class="mb-0 page-title d-flex align-items-center">
                    <i class="bi bi-person-fill-gear me-2"></i> 
                    <c:out value="${not empty usuario && usuario.id > 0 ? 'Editar Usuário' : 'Novo Usuário'}" />
                </h3>
            </div>

            <div class="card-body p-4">
                
                <c:if test="${not empty usuario && usuario.id > 0}">
                    <div class="alert alert-info d-flex align-items-center" role="alert">
                        <i class="bi bi-info-circle-fill me-2"></i>
                        <div><strong>Modo de Edição:</strong> Os campos CPF e Tipo de Usuário não podem ser alterados.</div>
                    </div>
                </c:if>
                <c:if test="${not empty erroCadastro}">
                    <div class="alert alert-danger d-flex align-items-center" role="alert">
                        <i class="bi bi-x-octagon-fill me-2"></i>
                        <div>${erroCadastro}</div>
                    </div>
                </c:if>

                <c:if test="${not empty usuario && usuario.id > 0}"><input type="hidden" name="id" value="${usuario.id}" /></c:if>

                <fieldset class="border p-3 mb-4">
                    <legend class="float-none w-auto px-2 fs-6">Dados Pessoais e de Acesso</legend>
                    <div class="row">
                        <div class="col-md-8 mb-3"><label for="nome" class="form-label">Nome Completo:</label><input type="text" class="form-control" id="nome" name="nome" value="<c:out value='${usuario.nome}'/>" required></div>
                        <div class="col-md-4 mb-3"><label for="cpf" class="form-label">CPF:</label><input type="text" class="form-control" id="cpf" name="cpf" value="<c:out value='${usuario.cpf}'/>" required <c:if test="${not empty usuario && usuario.id > 0}">readonly</c:if>><div id="msgCpf" class="form-text"></div></div>
                    </div>
                    <div class="row">
                        <div class="col-md-8 mb-3"><label for="email" class="form-label">Email:</label><input type="email" class="form-control" id="email" name="email" value="<c:out value='${usuario.email}'/>" required></div>
                        <div class="col-md-4 mb-3"><label for="senha" class="form-label">Senha:</label><input type="password" class="form-control" id="senha" name="senha" placeholder="${not empty usuario && usuario.id > 0 ? 'Deixe em branco para não alterar' : ''}" ${not empty usuario && usuario.id > 0 ? '' : 'required'}></div>
                    </div>
                </fieldset>
                
                <div id="advogado-fields" style="display: none;">
                    <fieldset class="border p-3 mb-4">
                        <legend class="float-none w-auto px-2 fs-6">Informações do Advogado (Obrigatório)</legend>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="oab" class="form-label">Nº OAB:</label>
                                <input type="text" class="form-control" id="oab" name="oab" value="<c:out value='${advogado.oab}'/>">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="especialidade" class="form-label">Especialidade Principal:</label>
                                <select id="especialidade" name="especialidade" class="form-select">
                                    <option value="Geral" ${advogado.especialidade == 'Geral' ? 'selected' : ''}>Geral</option>
                                    <option value="Civil" ${advogado.especialidade == 'Civil' ? 'selected' : ''}>Direito Civil</option>
                                    <option value="Criminal" ${advogado.especialidade == 'Criminal' ? 'selected' : ''}>Direito Criminal</option>
                                    <option value="Trabalhista" ${advogado.especialidade == 'Trabalhista' ? 'selected' : ''}>Direito Trabalhista</option>
                                    <option value="Empresarial" ${advogado.especialidade == 'Empresarial' ? 'selected' : ''}>Direito Empresarial</option>
                                </select>
                            </div>
                        </div>
                    </fieldset>
                </div>
                <fieldset class="border p-3 mb-4">
                    <legend class="float-none w-auto px-2 fs-6">Endereço e Contato</legend>
                    <div class="row">
                        <div class="col-md-4 mb-3"><label for="cep" class="form-label">CEP:</label><input type="text" class="form-control" id="cep" name="cep" placeholder="00000-000" value="<c:out value='${usuario.cep}'/>"><div id="msgCep" class="form-text"></div></div>
                        <div class="col-md-8 mb-3"><label for="endereco" class="form-label">Endereço (Rua, Nº):</label><input type="text" class="form-control" id="endereco" name="endereco" value="<c:out value='${usuario.endereco}'/>"></div>
                    </div>
                    <div class="row">
                        <div class="col-md-5 mb-3"><label for="bairro" class="form-label">Bairro:</label><input type="text" class="form-control" id="bairro" name="bairro" value="<c:out value='${usuario.bairro}'/>"></div>
                        <div class="col-md-5 mb-3"><label for="cidade" class="form-label">Cidade:</label><input type="text" class="form-control" id="cidade" name="cidade" value="<c:out value='${usuario.cidade}'/>"></div>
                        <div class="col-md-2 mb-3"><label for="uf" class="form-label">UF:</label><input type="text" class="form-control" id="uf" name="uf" maxlength="2" value="<c:out value='${usuario.uf}'/>"></div>
                    </div>
                     <div class="row">
                        <div class="col-md-6 mb-3"><label for="telefone" class="form-label">Telefone:</label><input type="text" class="form-control" id="telefone" name="telefone" value="<c:out value='${usuario.telefone}'/>"></div>
                    </div>
                </fieldset>

                <fieldset class="border p-3 mb-4">
                    <legend class="float-none w-auto px-2 fs-6">Configurações do Sistema</legend>
                    <div class="row">
                        <div class="col-md-6 mb-3"><label for="tipoUsuario" class="form-label">Tipo de Usuário:</label><select class="form-select" id="tipoUsuario" name="tipoUsuario" required <c:if test="${not empty usuario && usuario.id > 0}">disabled</c:if>><option value="cliente" ${usuario.tipoUsuario == 'cliente' ? 'selected' : ''}>Cliente</option><option value="advogado" id="opcaoAdvogado" ${usuario.tipoUsuario == 'advogado' ? 'selected' : ''} <c:if test="${empty usuario || usuario.id == 0}">disabled</c:if>>Advogado</option><c:if test="${not empty usuario && usuario.tipoUsuario == 'administrador'}"><option value="administrador" selected>Administrador</option></c:if></select><c:if test="${not empty usuario && usuario.id > 0}"><input type="hidden" name="tipoUsuario" value="${usuario.tipoUsuario}" /></c:if></div>
                        <div class="col-md-6 mb-3"><label for="ativo" class="form-label">Status da Conta:</label><select class="form-select" id="ativo" name="ativo" required><option value="S" ${usuario.ativo == 'S' ? 'selected' : ''}>Ativo</option><option value="N" ${usuario.ativo == 'N' ? 'selected' : ''}>Inativo</option></select></div>
                    </div>
                </fieldset>
            </div>

            <div class="card-footer bg-white text-end py-3">
                <a href="${pageContext.request.contextPath}/admin/usuario?action=listar" class="btn btn-outline-secondary me-2"><i class="bi bi-x-lg me-1"></i> Cancelar</a>
                <button type="submit" class="btn btn-primary"><i class="bi bi-check-lg me-1"></i> Salvar Alterações</button>
            </div>
        </form>
    </div>
</div>

<footer class="py-4 bg-dark text-white mt-auto">
    <div class="container text-center"><p class="mb-0">&copy; 2025 Escritório MaLu. Todos os direitos reservados.</p></div>
</footer>
    
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
$(document).ready(function() {
    var debounceCpf;
    var campoCpf = $('#cpf');
    var msgCpf = $('#msgCpf');
    var opcaoAdvogado = $('#opcaoAdvogado');

    function verificarCpf(cpf) {
        $.ajax({
            url: '${pageContext.request.contextPath}/verificaCpf',
            type: 'POST', data: { cpf: cpf }, dataType: 'json',
            success: function(response) {
                if (response.podeSerAdvogado) {
                    msgCpf.html('<i class="bi bi-check-circle-fill text-success"></i> CPF pré-cadastrado.').removeClass('text-danger text-info').addClass('text-success');
                    opcaoAdvogado.prop('disabled', false).text('Advogado');
                } else {
                    msgCpf.html('<i class="bi bi-info-circle-fill text-info"></i> Será cadastrado como Cliente.').removeClass('text-success text-danger').addClass('text-info');
                    opcaoAdvogado.prop('disabled', true).text('Advogado (CPF não verificado)');
                    $('#tipoUsuario').val('cliente');
                }
            },
            error: function() { msgCpf.html('<i class="bi bi-x-circle-fill text-danger"></i> Erro ao verificar CPF.').addClass('text-danger'); }
        });
    }
    
    if (campoCpf.is(':not([readonly])')) {
        campoCpf.on('input', function() {
            var value = $(this).val().replace(/\D/g, "");
            if (value.length > 11) value = value.slice(0, 11);
            value = value.replace(/(\d{3})(\d)/, "$1.$2").replace(/(\d{3})(\d)/, "$1.$2").replace(/(\d{3})(\d{1,2})$/, "$1-$2");
            $(this).val(value);
            
            clearTimeout(debounceCpf);
            var cpfDigits = value.replace(/\D/g, "");
            if (cpfDigits.length === 11) {
                msgCpf.html('<div class="spinner-border spinner-border-sm" role="status"></div> Verificando...');
                debounceCpf = setTimeout(function() { verificarCpf(cpfDigits); }, 800);
            } else {
                msgCpf.text('');
                opcaoAdvogado.prop('disabled', true).text('Advogado (CPF não verificado)');
                $('#tipoUsuario').val('cliente');
            }
        });
    }
    
    var campoCep = $('#cep');
    var msgCep = $('#msgCep');
    campoCep.on('input', function() {
        var cep = $(this).val().replace(/\D/g, '');
        if (cep.length > 8) cep = cep.slice(0, 8);
        cep = cep.replace(/^(\d{5})(\d)/, "$1-$2");
        $(this).val(cep);
    });
    campoCep.on('blur', function() {
        var cep = $(this).val().replace(/\D/g, '');
        if (cep.length === 8) {
            msgCep.html('<div class="spinner-border spinner-border-sm" role="status"></div> Buscando...');
            $.getJSON("https://viacep.com.br/ws/" + cep + "/json/?callback=?", function(dados) {
                if (!("erro" in dados)) {
                    $("#endereco").val(dados.logradouro); $("#bairro").val(dados.bairro); $("#cidade").val(dados.localidade); $("#uf").val(dados.uf);
                    msgCep.empty(); $("#endereco").focus();
                } else {
                    msgCep.text('CEP não encontrado.').addClass('text-danger');
                }
            }).fail(function() {
                msgCep.text('Erro ao consultar CEP.').addClass('text-danger');
            });
        } else if (cep.length > 0) {
            msgCep.text('Formato de CEP inválido.').addClass('text-danger');
        } else {
            msgCep.text('');
        }
    });


    var tipoUsuarioSelect = $('#tipoUsuario');
    var advogadoFields = $('#advogado-fields');
    var oabInput = $('#oab');
    var especialidadeInput = $('#especialidade');

    function toggleAdvogadoFields() {
        if (tipoUsuarioSelect.val() === 'advogado') {
            advogadoFields.slideDown(300);
            oabInput.prop('required', true);
            especialidadeInput.prop('required', true);
        } else {
            advogadoFields.slideUp(300);
            oabInput.prop('required', false);
            especialidadeInput.prop('required', false);
        }
    }
    

    toggleAdvogadoFields(); 
    
  
    tipoUsuarioSelect.on('change', toggleAdvogadoFields);
});
</script>
</body>
</html>