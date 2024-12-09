function addRecord() {
    var id = $("#id").val();
    var name = $("#name").val();
    var owner = $("#owner").val();
    var species = $("#species").val();
    var sex = $("#sex").val();
    var birth = $("#birth").val();
    var death = $("#death").val();
  
    $.post("../cgi-bin/agregar_registro.pl", {
      id: id,
      name: name,
      owner: owner,
      species: species,
      sex: sex,
      birth: birth,
      death: death
    }, function (response) {
      if (response.status === "success") {
        alert("Registro agregado correctamente");
        $("#add_new_pet_modal").modal("hide");
        readRecords(); 
      } else {
        alert("Error: " + response.message);
      }
    }).fail(function () {
      alert("Error al enviar los datos.");
    });
  }

function readRecords() {
    $.get("../cgi-bin/leer_registros.pl", {}, function (data) {
        $("#records_content").html(data);
    }).fail(function () {
        alert("Error al cargar los registros.");
    });
}

function deleteRecord(id) {
    console.log("Intentando eliminar el registro con ID:", id);
    if (confirm("¿Está seguro de eliminar el registro?")) {
        $.post("../cgi-bin/eliminar_registros.pl", { id: id }, function (data) {
            console.log("Respuesta del servidor:", data);
            readRecords();
        }).fail(function () {
            alert("Error al eliminar el registro.");
        });
    }
}

function GetUserDetails(id) {
    $("#hidden_user_id").val(id);
    $.post("../cgi-bin/leer_detalles_registro.pl", { id: id }, function (response, status) {
        if (response.status === 200) {
            var pet = response.data;

            $("#update_name").val(pet.name);
            $("#update_owner").val(pet.owner);
            $("#update_species").val(pet.species);
            $("#update_sex").val(pet.sex);
            $("#update_birth").val(pet.birth);
            $("#update_death").val(pet.death);
        } else {
            alert("Error: " + response.message);
        }
    }, "json");

    $("#update_pet_modal").modal("show");
}

function UpdateUserDetails() {
    var name = $("#update_name").val();
    var owner = $("#update_owner").val();
    var species = $("#update_species").val();
    var sex = $("#update_sex").val();
    var birth = $("#update_birth").val();
    var death = $("#update_death").val();
    var id = $("#hidden_user_id").val();

    $.post("../cgi-bin/actualizar_registros.pl", {
        id: id,
        name: name,
        owner: owner,
        species: species,
        sex: sex,
        birth: birth,
        death: death
    }, function (data, status) {
        // Ocultar el modal después de guardar
        $("#update_pet_modal").modal("hide");
        readRecords(); 
    });
}

$(document).ready(function () {
    readRecords();
});
