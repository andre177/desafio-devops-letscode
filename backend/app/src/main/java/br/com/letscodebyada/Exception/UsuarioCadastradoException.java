package br.com.letscodebyada.Exception;

public class UsuarioCadastradoException extends RuntimeException {

    public UsuarioCadastradoException(String login){
        super("Usuario já cadastrado para o login " + login);
    }
}
