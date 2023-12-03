package com.mamud.certificateconversion

import org.springframework.http.HttpHeaders
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import org.springframework.web.multipart.MultipartFile

@RestController
class ConvertController {

    @PostMapping("/convert")
    fun postConvert(@RequestParam("file") file: MultipartFile,
                    @RequestParam("password") password: String): ResponseEntity<ByteArray> {
        if (file.isEmpty) {
            throw InvalidFileException("File is empty")
        }

        if (password.isEmpty()) {
            throw InvalidFileException("Password is empty")
        }

        try {
            val certificate = ConvertService().convertCertificate(file, password);

            val headers = HttpHeaders()
            headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=certificate.zip")
            return ResponseEntity(certificate, headers, HttpStatus.OK)
        } catch (e: Exception) {
            throw InvalidFileException("Error converting file")
        }
    }

    @GetMapping("/health")
    fun getHealth() : ResponseEntity<String> {
        return ResponseEntity("OK", HttpStatus.OK)
    }

    @GetMapping("/")
    fun getRoot() : ResponseEntity<String> {
        return ResponseEntity("OK", HttpStatus.OK)
    }

    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(InvalidFileException::class)
    fun handleInvalidFileException(ex: InvalidFileException): String {
        return ex.message ?: "Invalid file"
    }
}