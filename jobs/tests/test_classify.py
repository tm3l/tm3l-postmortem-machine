from postmortem_jobs.classify import classify_failure_mode


def test_classify_failure_mode_smoke():
    result = classify_failure_mode({})
    assert len(result) > 0
    assert "taxonomy_id" in result[0]
