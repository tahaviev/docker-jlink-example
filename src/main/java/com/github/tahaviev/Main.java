package com.github.tahaviev;

import com.sun.net.httpserver.HttpServer;
import java.io.OutputStream;
import java.net.InetSocketAddress;

public final class Main {

    public static void main(final String... args) throws Exception {
        final HttpServer server = HttpServer.create(
            new InetSocketAddress(80), 0
        );
        server.createContext(
            "/",
            exchange -> {
                final byte[] bytes = "Hello world".getBytes();
                exchange.sendResponseHeaders(200, bytes.length);
                try (OutputStream output = exchange.getResponseBody()) {
                    output.write(bytes);
                }
            }
        );
        server.start();
    }

}
