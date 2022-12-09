package br.com.letscodebyada.Repository;

import br.com.letscodebyada.Model.UsuarioModel;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UsuarioRepository extends JpaRepository<UsuarioModel, Integer> {

    Optional<UsuarioModel> findByUsername(String username);

    boolean existsByUsername(String username);
}
