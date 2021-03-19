/// <reference types="cypress" />

context("Actions", () => {
  beforeEach(() => {
    cy.visit("http://localhost:8080");
  });

  it("does stuff", () => {
    // https://on.cypress.io/type
    cy.wait(4000);
    cy.get("#input-display")
      .type("Hello, World!")
      .should("have.text", "      ＞Hello, World!\n    ");

    cy.get("#input-display").type("{leftarrow}");
    cy.get("#terminal-caret").should("have.text", "!");
    cy.get("#input-display").type("{leftarrow}");
    cy.get("#terminal-caret").should("have.text", "d");
    cy.get("#input-display").type("{rightarrow}");
    cy.get("#terminal-caret").should("have.text", "!");

    cy.get("#input-display")
      .type("!")
      .should("have.text", "      ＞Hello, World!!\n    ");
    cy.get("#input-display").type("{rightarrow}");
    cy.get("#terminal-caret").should("have.text", "\n    ");
  });
});
