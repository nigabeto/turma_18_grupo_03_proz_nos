document.addEventListener("DOMContentLoaded", function() {
    const button = document.getElementById("button");
    const nome = document.getElementById("nome");
    const sobrenome = document.getElementById("sobrenome");
    const email = document.getElementById("email");
    const regiao = document.getElementById("regiao_option");
    const form = document.querySelector("form");
    
    button.addEventListener("click", (event) => {
        event.preventDefault();
        if (validateForm()) {
            form.submit();
            alert("Formulário enviado com sucesso!");
        }
    });

    function validateForm() {
        if (nome.value === "") {
            alert("Por favor, preencha seu nome");
            return false;
        }
        if (sobrenome.value === "") {
            alert("Por favor, preencha seu sobrenome");
            return false;
        }
        if (email.value === "") {
            alert("Por favor, preencha seu email");
            return false;
        }
        if (!isValidEmail(email.value)) {
            alert("Por favor, insira um email válido");
            return false;
        }
        if (regiao.value === "") {
            alert("Por favor, selecione sua região");
            return false;
        }
        return true;
    }

    function isValidEmail(email) {
        // Expressão regular para validar o formato do email
        const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return regex.test(email);
    }
});