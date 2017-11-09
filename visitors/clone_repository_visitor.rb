class CloneRepositoryVisitor
  def visit(subject)
    # things to do
    # 1 - mudar a branch para a branch alvo
    Rugged::Repository.clone_at(subject.repository , "./tmp", {
        transfer_progress: lambda { |total_objects, indexed_objects,
            received_objects, local_objects, total_deltas, indexed_deltas, received_bytes|
          pp total_objects, received_objects}, checkout_branch: subject.branch } )
  end
end