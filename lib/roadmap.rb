module Roadmap

  def get_roadmap(id)
    response = self.class.get("/roadmaps/#{id}", headers: { authorization: auth_token })
    JSON.parse(response.body)
  end

  def get_checkpoint(id)
    response = self.class.get("/checkpoints/#{id}", headers: { authorization: auth_token })
    JSON.parse(response.body)
  end

  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment)
    enrollment_id = self.get_me['id']
    response = self.class.post("/checkpoint_submissions",
      headers: { authorization: auth_token },
      body: {
          assignment_branch: assignment_branch,
          assignment_commit_link: assignment_commit_link,
          checkpoint_id: checkpoint_id,
          enrollment_id: enrollment_id,
          comment: comment
      })

      JSON.parse(response.body)
  end
# closes module
end
